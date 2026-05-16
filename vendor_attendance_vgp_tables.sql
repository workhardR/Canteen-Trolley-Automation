-- ============================================================
-- DDL: Visitor Gate Pass (VGP) System — Oracle DB Tables
-- ============================================================

-- Users table
CREATE TABLE t_VGP_Users (
    user_id        VARCHAR2(20)  PRIMARY KEY,
    user_name      VARCHAR2(100) NOT NULL,
    password_hash  VARCHAR2(200) NOT NULL,   -- bcrypt hash
    role           VARCHAR2(20)  NOT NULL
        CHECK (role IN ('admin', 'security', 'reception', 'itadmin')),
    location_id    NUMBER,
    canteen_id     NUMBER,
    is_active      CHAR(1)       DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
    created_on     TIMESTAMP     DEFAULT SYSTIMESTAMP
);

-- Visitor log table
CREATE TABLE t_VGP_Visitor_Log (
    visitor_id    NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    visitor_name  VARCHAR2(100)  NOT NULL,
    host_emp_id   VARCHAR2(20)   NOT NULL,   -- Employee being visited
    purpose       VARCHAR2(200)  NOT NULL,
    vehicle_no    VARCHAR2(20),
    mobile_no     VARCHAR2(15),
    visit_date    DATE           DEFAULT TRUNC(SYSDATE),
    entry_time    TIMESTAMP      DEFAULT SYSTIMESTAMP,
    exit_time     TIMESTAMP,
    status        VARCHAR2(10)   DEFAULT 'IN'
        CHECK (status IN ('IN', 'OUT')),
    badge_no      VARCHAR2(20),
    created_by    VARCHAR2(50),
    created_on    TIMESTAMP      DEFAULT SYSTIMESTAMP
);

-- Indexes
CREATE INDEX idx_vgp_visit_date   ON t_VGP_Visitor_Log (visit_date);
CREATE INDEX idx_vgp_host_emp     ON t_VGP_Visitor_Log (host_emp_id);
CREATE INDEX idx_vgp_status       ON t_VGP_Visitor_Log (status, visit_date);

