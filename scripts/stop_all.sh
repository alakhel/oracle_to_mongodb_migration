#!/bin/bash
. /home/oracle/scripts/setEnv.sh
export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES
sqlplus -S / AS SYSDBA @/home/oracle/scripts/pdb_stop.sql
dbshut \$ORACLE_HOME
