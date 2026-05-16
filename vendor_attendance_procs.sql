-- ============================================================
-- PL/SQL Stored Procedures
-- Project: Automation of Canteen Trolley Operation
-- ============================================================


-- ============================================================
-- 1. PROCEDURE: proc_punch_in
--    Handles vendor punch-in with all business validations
-- ============================================================
CREATE OR REPLACE PROCEDURE proc_punch_in (
    p_sp_no       IN  VARCHAR2,
    p_location_id IN  NUMBER,
    p_canteen_id  IN  NUMBER,
    p_pickup_id   IN  NUMBER,
    p_meal_id     IN  NUMBER,
    p_created_by  IN  VARCHAR2,
    p_status_msg  OUT VARCHAR2    -- 'SUCCESS' or error reason
)
AS
    v_diff_pickup_count NUMBER := 0;
BEGIN
    -- Rule 1: Vendor must not be punched-in at a DIFFERENT pickup point
    --         for the same date, sp_no, and meal_id
    SELECT COUNT(*)
      INTO v_diff_pickup_count
      FROM t_Vendor_Attendance
     WHERE sp_no      = p_sp_no
       AND meal_id    = p_meal_id
       AND punch_date = TRUNC(SYSDATE)
       AND pickup_id  != p_pickup_id
       AND status     = 'IN';

    IF v_diff_pickup_count > 0 THEN
        p_status_msg := 'ALREADY_PUNCHED_IN_DIFFERENT_LOCATION';
        RETURN;
    END IF;

    -- Rule 2: Insert punch-in record (multiple punch-ins allowed at same pickup)
    INSERT INTO t_Vendor_Attendance
        (sp_no, location_id, canteen_id, pickup_id, meal_id,
         punch_in_time, punch_date, status, created_by)
    VALUES
        (p_sp_no, p_location_id, p_canteen_id, p_pickup_id, p_meal_id,
         SYSTIMESTAMP, TRUNC(SYSDATE), 'IN', p_created_by);

    COMMIT;
    p_status_msg := 'PUNCH_IN_SUCCESSFUL';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_status_msg := 'ERROR: ' || SQLERRM;
END proc_punch_in;
/


-- ============================================================
-- 2. PROCEDURE: proc_punch_out
--    Handles vendor punch-out; punch-out count <= punch-in count
-- ============================================================
CREATE OR REPLACE PROCEDURE proc_punch_out (
    p_sp_no       IN  VARCHAR2,
    p_pickup_id   IN  NUMBER,
    p_meal_id     IN  NUMBER,
    p_modified_by IN  VARCHAR2,
    p_status_msg  OUT VARCHAR2
)
AS
    v_punch_in_count  NUMBER := 0;
    v_punch_out_count NUMBER := 0;
    v_record_id       NUMBER := 0;
BEGIN
    -- Count total punch-ins for this sp_no, pickup, meal, date
    SELECT COUNT(*)
      INTO v_punch_in_count
      FROM t_Vendor_Attendance
     WHERE sp_no      = p_sp_no
       AND pickup_id  = p_pickup_id
       AND meal_id    = p_meal_id
       AND punch_date = TRUNC(SYSDATE);

    -- Count total punch-outs already done
    SELECT COUNT(*)
      INTO v_punch_out_count
      FROM t_Vendor_Attendance
     WHERE sp_no          = p_sp_no
       AND pickup_id      = p_pickup_id
       AND meal_id        = p_meal_id
       AND punch_date     = TRUNC(SYSDATE)
       AND punch_out_time IS NOT NULL;

    IF v_punch_in_count = 0 THEN
        p_status_msg := 'NO_PUNCH_IN_FOUND';
        RETURN;
    END IF;

    IF v_punch_out_count >= v_punch_in_count THEN
        p_status_msg := 'MAX_PUNCH_OUT_DONE';
        RETURN;
    END IF;

    -- Get the latest un-punched-out record
    SELECT id
      INTO v_record_id
      FROM t_Vendor_Attendance
     WHERE sp_no          = p_sp_no
       AND pickup_id      = p_pickup_id
       AND meal_id        = p_meal_id
       AND punch_date     = TRUNC(SYSDATE)
       AND punch_out_time IS NULL
       AND ROWNUM         = 1
     ORDER BY punch_in_time ASC;

    UPDATE t_Vendor_Attendance
       SET punch_out_time = SYSTIMESTAMP,
           status         = 'OUT',
           modified_by    = p_modified_by,
           modified_on    = SYSTIMESTAMP
     WHERE id = v_record_id;

    COMMIT;
    p_status_msg := 'PUNCH_OUT_SUCCESSFUL';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_status_msg := 'ERROR: ' || SQLERRM;
END proc_punch_out;
/


-- ============================================================
-- 3. FUNCTION: fn_is_punched_in
--    Returns 1 if vendor is currently punched-in, else 0
--    Used by Booking/Delivery pages to gate access
-- ============================================================
CREATE OR REPLACE FUNCTION fn_is_punched_in (
    p_sp_no   IN  VARCHAR2,
    p_meal_id IN  NUMBER
) RETURN NUMBER
AS
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM t_Vendor_Attendance
     WHERE sp_no      = p_sp_no
       AND meal_id    = p_meal_id
       AND punch_date = TRUNC(SYSDATE)
       AND status     = 'IN';

    IF v_count > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END fn_is_punched_in;
/


-- ============================================================
-- 4. PROCEDURE: proc_get_attendance_individual
--    Returns attendance for a given sp_no and date range
-- ============================================================
CREATE OR REPLACE PROCEDURE proc_get_attendance_individual (
    p_sp_no      IN  VARCHAR2,
    p_from_date  IN  DATE,
    p_to_date    IN  DATE,
    p_cursor     OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            sp_no,
            canteen_id,
            pickup_id,
            meal_id,
            punch_date,
            punch_in_time,
            punch_out_time,
            status
        FROM t_Vendor_Attendance
       WHERE sp_no      = p_sp_no
         AND punch_date BETWEEN p_from_date AND p_to_date
       ORDER BY punch_date, punch_in_time;
END proc_get_attendance_individual;
/


-- ============================================================
-- 5. PROCEDURE: proc_get_attendance_canteen_wise
--    Returns attendance grouped by canteen for a date range
-- ============================================================
CREATE OR REPLACE PROCEDURE proc_get_attendance_canteen_wise (
    p_canteen_id IN  NUMBER,
    p_meal_id    IN  NUMBER,
    p_from_date  IN  DATE,
    p_to_date    IN  DATE,
    p_cursor     OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            canteen_id,
            meal_id,
            punch_date,
            sp_no,
            COUNT(*) AS total_punch_in,
            SUM(CASE WHEN punch_out_time IS NOT NULL THEN 1 ELSE 0 END) AS total_punch_out
        FROM t_Vendor_Attendance
       WHERE canteen_id = p_canteen_id
         AND meal_id    = p_meal_id
         AND punch_date BETWEEN p_from_date AND p_to_date
       GROUP BY canteen_id, meal_id, punch_date, sp_no
       ORDER BY punch_date, sp_no;
END proc_get_attendance_canteen_wise;
/

