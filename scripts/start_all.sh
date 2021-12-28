#!/bin/bash
. /home/oracle/scripts/setEnv.sh
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
dbstart $ORACLE_HOME
sqlplus -S / AS SYSDBA @/home/oracle/scripts/pdb_start.sql
