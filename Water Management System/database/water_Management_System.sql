USE water_service_management;

CREATE TABLE RESIDENT (
    Resident_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Contact_Number VARCHAR(20),
    Email VARCHAR(100) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE PERSONNEL (
    Personnel_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Contact_Number VARCHAR(20),
    Email VARCHAR(100) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE USER_ACCOUNT (
    Account_ID INT AUTO_INCREMENT PRIMARY KEY,
    Resident_ID INT NULL UNIQUE,
    Personnel_ID INT NULL UNIQUE,
    Role VARCHAR(20) NOT NULL,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Account_Status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_account_resident
        FOREIGN KEY (Resident_ID)
        REFERENCES RESIDENT(Resident_ID)
        ON DELETE RESTRICT,

    CONSTRAINT fk_account_personnel
        FOREIGN KEY (Personnel_ID)
        REFERENCES PERSONNEL(Personnel_ID)
        ON DELETE RESTRICT,

    CONSTRAINT chk_account_role
        CHECK (Role IN ('Admin', 'Personnel', 'Resident')),

    CONSTRAINT chk_account_status
        CHECK (Account_Status IN ('Active', 'Inactive')),

    CONSTRAINT chk_account_role_link
        CHECK (
            (Role = 'Admin'     AND Resident_ID IS NULL     AND Personnel_ID IS NULL) OR
            (Role = 'Personnel' AND Resident_ID IS NULL     AND Personnel_ID IS NOT NULL) OR
            (Role = 'Resident'  AND Resident_ID IS NOT NULL AND Personnel_ID IS NULL)
        )
) ENGINE=InnoDB;

CREATE TABLE SERVICE_CONCERN (
    Concern_ID INT AUTO_INCREMENT PRIMARY KEY,
    Resident_ID INT NOT NULL,
    Concern_Type VARCHAR(50) NOT NULL,
    Description TEXT NOT NULL,
    Date_Reported DATETIME NOT NULL,
    Priority VARCHAR(20) NOT NULL,
    Status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_concern_resident
        FOREIGN KEY (Resident_ID)
        REFERENCES RESIDENT(Resident_ID)
        ON DELETE RESTRICT,

    CONSTRAINT chk_concern_priority
        CHECK (Priority IN ('Low', 'Medium', 'High')),

    CONSTRAINT chk_concern_status
        CHECK (Status IN ('Pending', 'Assigned', 'In Progress', 'Resolved'))
) ENGINE=InnoDB;

CREATE TABLE ASSIGNMENT (
    Assignment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Concern_ID INT NOT NULL,
    Personnel_ID INT NOT NULL,
    Assigned_Date DATETIME NOT NULL,
    Assignment_Status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_assignment_concern
        FOREIGN KEY (Concern_ID)
        REFERENCES SERVICE_CONCERN(Concern_ID)
        ON DELETE RESTRICT,

    CONSTRAINT fk_assignment_personnel
        FOREIGN KEY (Personnel_ID)
        REFERENCES PERSONNEL(Personnel_ID)
        ON DELETE RESTRICT,

    CONSTRAINT chk_assignment_status
        CHECK (Assignment_Status IN ('Assigned', 'In Progress', 'Completed'))
) ENGINE=InnoDB;

CREATE TABLE SERVICE_ACTION (
    Action_ID INT AUTO_INCREMENT PRIMARY KEY,
    Concern_ID INT NOT NULL,
    Personnel_ID INT NOT NULL,
    Action_Description TEXT NOT NULL,
    Action_Date DATETIME NOT NULL,

    CONSTRAINT fk_action_concern
        FOREIGN KEY (Concern_ID)
        REFERENCES SERVICE_CONCERN(Concern_ID)
        ON DELETE RESTRICT,

    CONSTRAINT fk_action_personnel
        FOREIGN KEY (Personnel_ID)
        REFERENCES PERSONNEL(Personnel_ID)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE WATER_SCHEDULE (
    Schedule_ID INT AUTO_INCREMENT PRIMARY KEY,
    Personnel_ID INT NOT NULL,
    Area VARCHAR(100) NOT NULL,
    Schedule_Date DATE NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    Schedule_Status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_schedule_personnel
        FOREIGN KEY (Personnel_ID)
        REFERENCES PERSONNEL(Personnel_ID)
        ON DELETE RESTRICT,

    CONSTRAINT chk_schedule_status
        CHECK (Schedule_Status IN ('Active', 'Changed', 'Cancelled')),

    CONSTRAINT chk_schedule_time
        CHECK (End_Time > Start_Time)
) ENGINE=InnoDB;

CREATE TABLE NOTIFICATION (
    Notification_ID INT AUTO_INCREMENT PRIMARY KEY,
    Personnel_ID INT NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Message TEXT NOT NULL,
    Notification_Type VARCHAR(50) NOT NULL,
    Date_Posted DATETIME NOT NULL,

    CONSTRAINT fk_notification_personnel
        FOREIGN KEY (Personnel_ID)
        REFERENCES PERSONNEL(Personnel_ID)
        ON DELETE RESTRICT,

    CONSTRAINT chk_notification_type
        CHECK (Notification_Type IN (
            'Schedule',
            'Interruption',
            'Service Update',
            'Announcement'
        ))
) ENGINE=InnoDB;

-- CREATE INDEXES

CREATE INDEX idx_concern_status_priority_date
    ON SERVICE_CONCERN (Status, Priority, Date_Reported);

CREATE INDEX idx_concern_resident_date
    ON SERVICE_CONCERN (Resident_ID, Date_Reported);

CREATE INDEX idx_assignment_personnel_status
    ON ASSIGNMENT (Personnel_ID, Assignment_Status);

CREATE INDEX idx_schedule_date_status
    ON WATER_SCHEDULE (Schedule_Date, Schedule_Status);

CREATE INDEX idx_notification_type_date
    ON NOTIFICATION (Notification_Type, Date_Posted);

CREATE INDEX idx_resident_fullname
    ON RESIDENT (Full_Name);

ANALYZE TABLE RESIDENT, SERVICE_CONCERN, ASSIGNMENT, WATER_SCHEDULE, NOTIFICATION;

SHOW INDEX FROM SERVICE_CONCERN;