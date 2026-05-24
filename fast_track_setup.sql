-- ============================================================
-- DDL: Create Tables for Fast Track Booking and Menu Items
-- Project: Automation of Canteen Trolley Operation
-- ============================================================

-- 1. Create Menu Items Table
CREATE TABLE t_Canteen_Menu_Item (
    item_id     NUMBER PRIMARY KEY,
    item_name   VARCHAR2(100) NOT NULL,
    is_active   CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N'))
);

-- 2. Create Fast Track Booking Table
CREATE TABLE t_Fast_Track_Booking (
    booking_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sp_no       VARCHAR2(20) NOT NULL,
    canteen_id  NUMBER NOT NULL REFERENCES t_Canteen_Master(canteen_id),
    pickup_id   NUMBER NOT NULL REFERENCES t_Canteen_Pickup(pickup_id),
    meal_id     NUMBER NOT NULL,
    item_id     NUMBER NOT NULL REFERENCES t_Canteen_Menu_Item(item_id),
    quantity    NUMBER NOT NULL,
    booked_on   TIMESTAMP DEFAULT SYSTIMESTAMP,
    status      VARCHAR2(20) DEFAULT 'BOOKED',
    created_by  VARCHAR2(50)
);

-- 3. Insert Base Menu Items
INSERT INTO t_Canteen_Menu_Item (item_id, item_name, is_active) VALUES (1, 'Standard Thali', 'Y');
INSERT INTO t_Canteen_Menu_Item (item_id, item_name, is_active) VALUES (2, 'Special Thali', 'Y');
INSERT INTO t_Canteen_Menu_Item (item_id, item_name, is_active) VALUES (3, 'Executive Meal', 'Y');
INSERT INTO t_Canteen_Menu_Item (item_id, item_name, is_active) VALUES (4, 'Mini Meals', 'Y');

-- Save everything
COMMIT;
