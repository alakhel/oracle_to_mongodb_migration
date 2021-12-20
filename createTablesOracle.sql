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
    CONSTRAINT robot_bu_fk FOREIGN KEY (bu_id) REFERENCES BusinessUnit(PID),
    CONSTRAINT robot_job_fk FOREIGN KEY (job_id) REFERENCES Job(ARID)
);


INSERT INTO Job VALUES (
    ()
)