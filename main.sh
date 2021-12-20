#!/bin/bash
# nétoyage de la collection personnes de la base adresses dans MongoDB
# on considère que la db (HR) et la collection (managers) existe déjà
mongo <<EOF
use HR
db.managers.remove({});
exit;
EOF


# Exctraction des donées : sqlplus -s username/password@sid @tmp.sql > output.txt
sqlplus -S AL/AL@/home/oracle/scripts/exctract.sql 

# read job then ((read robot, write it in mongo save id)) save it with the robot id

# Load 
mongoimport --db iot --collection x --file 