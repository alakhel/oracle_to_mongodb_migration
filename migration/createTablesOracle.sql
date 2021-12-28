Rem
Rem
Rem
Rem
Rem
PROMPT 
PROMPT specify password for AL as parameter 1:
DEFINE pass    = &1
PROMPT 
REM =======================================================
REM cleanup 
REM =======================================================
CONNECT sys/&pass@localhost/pdb1.localdomain AS SYSDBA;
DROP USER AL CASCADE;

REM =======================================================
REM create user
REM =======================================================
CREATE USER al IDENTIFIED BY &pass;




ALTER USER al DEFAULT TABLESPACE users
              QUOTA UNLIMITED ON users;

ALTER USER al TEMPORARY TABLESPACE temp;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO al;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO al;


REM =======================================================
REM grants from sys schema
REM =======================================================

CONNECT sys/&pass@localhost/pdb1.localdomain AS SYSDBA;
GRANT execute ON sys.dbms_stats TO al;

REM =======================================================
REM create al schema objects
REM =======================================================

CONNECT al/&pass@localhost/pdb1.localdomain

ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;


REM ********************************************************************
REM creation table Job
Rem
Prompt ******  Creating Job table ....
CREATE TABLE Job (
    job_id VARCHAR2(6) CONSTRAINT job_id_nn NOT NULL,
    job_name VARCHAR2(50) CONSTRAINT name_nn NOT NULL CONSTRAINT name_unique UNIQUE,
    description VARCHAR2(50)
);
ALTER TABLE Job ADD (
    CONSTRAINT pk_job_id PRIMARY KEY (job_id)
);
REM ********************************************************************
Prompt ******  Creating BusinessUnit table ....
CREATE TABLE BusinessUnit (
    bu_id VARCHAR2(6) CONSTRAINT bu_id_nn NOT NULL,
    bu_name VARCHAR2(50),
    location VARCHAR2(50),
    description VARCHAR2(50),
    manager_first_name VARCHAR2(50),
    manager_last_name VARCHAR2(50)
);
ALTER TABLE BusinessUnit ADD (
    CONSTRAINT pk_bu_id PRIMARY KEY (bu_id)
);


REM ********************************************************************
REM creation table Robot
Rem
Prompt ******  Creating Robot table ....
CREATE TABLE Robot (
    robot_id VARCHAR2(6) CONSTRAINT robot_id_nn NOT NULL,
    robot_name VARCHAR2(50),
    bu_id VARCHAR2(6),
    job_id VARCHAR2(6)
);
ALTER TABLE Robot ADD (
    CONSTRAINT pk_robot_id PRIMARY KEY (robot_id),
    CONSTRAINT robot_bu_fk FOREIGN KEY (bu_id) REFERENCES BusinessUnit(bu_id),
    CONSTRAINT robot_job_fk FOREIGN KEY (job_id) REFERENCES Job(job_id)
);

REM ********************************************************************
REM Data insert
Rem
Prompt ******  Data insert - Job table ....
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB001', 'Cut', 'cut');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB002', 'Paint', 'paint');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB003', 'Clean', 'clean');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB004', 'PickUp', 'pick up');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB005', 'Store', 'store');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB006', 'Pull', 'pull');
INSERT INTO Job (job_id, job_name, description) VALUES ('JOB007', 'Push', 'push');

REM ********************************************************************
REM Data insert
Rem
Prompt ******  Data insert - BusinessUnit table ....
INSERT INTO BusinessUnit (bu_id, bu_name, location, description, manager_first_name, manager_last_name ) 
                VALUES ('BU0001', 'Paris La Défense', 'La Défense', 'Paris La Défense management office', 'Alex', 'Pink');
INSERT INTO BusinessUnit (bu_id, bu_name, location, description, manager_first_name, manager_last_name ) 
                VALUES ('BU0002', 'Paris Bercy', 'Bercy', 'Bercy Lab', 'Kum', 'Yu');
INSERT INTO BusinessUnit (bu_id, bu_name, location, description, manager_first_name, manager_last_name ) 
                VALUES ('BU0003', 'The moon', 'La Lune', 'The moon lab for critical ops', 'Ax-01-b', '00');

REM ********************************************************************
REM Data insert
Rem
Prompt ******  Data insert - Robot table ....
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT310', 'Rm-yy-310', 'BU0003','JOB001');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT210', 'Rm-yy-210', 'BU0002','JOB001');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT220', 'Rm-yy-220', 'BU0002','JOB002');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT230', 'Rm-yy-230', 'BU0002','JOB003');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT340', 'Rm-yy-340', 'BU0003','JOB004');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT330', 'Rm-yy-330', 'BU0003','JOB003');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT140', 'Rm-yy-340', 'BU0001','JOB001');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT350', 'Rm-yy-350', 'BU0003','JOB005');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT360', 'Rm-yy-360', 'BU0003','JOB006');
INSERT INTO ROBOT (robot_id, robot_name, bu_id, job_id) VALUES ('RBT370', 'Rm-yy-370', 'BU0003','JOB007');
exit;



