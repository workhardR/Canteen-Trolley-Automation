-- ============================================================
-- DDL: Create t_Vendor_Attendance Table
-- Project: Automation of Canteen Trolley Operation
-- ============================================================

CREATE TABLE t_Vendor_Attendance (
    id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sp_no           VARCHAR2(20)    NOT NULL,           -- Service Personnel Number
    location_id     NUMBER          NOT NULL,           -- Location/Canteen ID
    canteen_id      NUMBER          NOT NULL,           -- Canteen Identifier
    pickup_id       NUMBER          NOT NULL,           -- Trolley pickup point ID
    meal_id         NUMBER          NOT NULL,           -- Meal type (1=Breakfast,2=Lunch,3=Snacks)
    punch_in_time   TIMESTAMP       DEFAULT SYSTIMESTAMP,
    punch_out_time  TIMESTAMP       NULL,
    punch_date      DATE            DEFAULT TRUNC(SYSDATE),
    status          VARCHAR2(10)    DEFAULT 'IN'        -- IN / OUT
        CHECK (status IN ('IN', 'OUT')),
    created_by      VARCHAR2(50),
    created_on      TIMESTAMP       DEFAULT SYSTIMESTAMP,
    modified_by     VARCHAR2(50),
    modified_on     TIMESTAMP
);

-- Indexes for frequent lookups
CREATE INDEX idx_va_spno_date      ON t_Vendor_Attendance (sp_no, punch_date);
CREATE INDEX idx_va_pickup_meal    ON t_Vendor_Attendance (pickup_id, meal_id, punch_date);
CREATE INDEX idx_va_canteen_meal   ON t_Vendor_Attendance (canteen_id, meal_id, punch_date);

-- ============================================================
-- DML: Sample seed data for testing
-- ============================================================

INSERT INTO t_Vendor_Attendance
    (sp_no, location_id, canteen_id, pickup_id, meal_id, punch_in_time, punch_date, status, created_by)
VALUES
    ('EMP001', 1, 101, 201, 1, SYSTIMESTAMP, TRUNC(SYSDATE), 'IN', 'SYSTEM');

INSERT INTO t_Vendor_Attendance
    (sp_no, location_id, canteen_id, pickup_id, meal_id, punch_in_time, punch_date, status, created_by)
VALUES
    ('EMP002', 1, 102, 202, 2, SYSTIMESTAMP, TRUNC(SYSDATE), 'IN', 'SYSTEM');

COMMIT;

