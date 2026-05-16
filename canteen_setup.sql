-- 1. Create Locations Table
CREATE TABLE t_Canteen_Location (
    location_id   NUMBER PRIMARY KEY,
    location_name VARCHAR2(100) NOT NULL
);

-- 2. Create Canteens Table
CREATE TABLE t_Canteen_Master (
    canteen_id    NUMBER PRIMARY KEY,
    canteen_name  VARCHAR2(100) NOT NULL,
    location_id   NUMBER REFERENCES t_Canteen_Location(location_id)
);

-- 3. Create Pickup Points Table
CREATE TABLE t_Canteen_Pickup (
    pickup_id     NUMBER PRIMARY KEY,
    pickup_name   VARCHAR2(100) NOT NULL,
    canteen_id    NUMBER REFERENCES t_Canteen_Master(canteen_id)
);

-- 4. Create Users Table
CREATE TABLE t_Canteen_Users (
    user_id       VARCHAR2(20) PRIMARY KEY,
    user_name     VARCHAR2(100) NOT NULL,
    password      VARCHAR2(50) NOT NULL,
    role          VARCHAR2(20) NOT NULL,
    location_id   NUMBER REFERENCES t_Canteen_Location(location_id),
    canteen_id    NUMBER REFERENCES t_Canteen_Master(canteen_id),
    is_active     CHAR(1) DEFAULT 'Y'
);

-- 5. Insert Base Data
INSERT INTO t_Canteen_Location (location_id, location_name) VALUES (1, 'Main Office');
INSERT INTO t_Canteen_Master (canteen_id, canteen_name, location_id) VALUES (101, 'Central Canteen', 1);
INSERT INTO t_Canteen_Pickup (pickup_id, pickup_name, canteen_id) VALUES (201, 'Main Gate Pickup', 101);
INSERT INTO t_Canteen_Pickup (pickup_id, pickup_name, canteen_id) VALUES (202, 'North Side Pickup', 101);

-- 6. Insert Default Admin User
INSERT INTO t_Canteen_Users (user_id, user_name, password, role, location_id, canteen_id, is_active) 
VALUES ('admin', 'Administrator', 'admin', 'admin', 1, 101, 'Y');

-- Save everything
COMMIT;

