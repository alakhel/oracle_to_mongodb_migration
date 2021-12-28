#!/bin/bash
# nétoyage de la collection personnes de la base adresses dans MongoDB
# on considère que la db (IOT) et la collection (managers) existe déjà
mongosh --authenticationDatabase admin -u "root" -p "toor" <<EOF
use IOT
db.BusinessUnit.deleteMany({});
db.Job.deleteMany({});
db.Robot.deleteMany({});
exit;
EOF

# base de données Oracle : pdb1
# utilisateur : al, mot de passe al
# récupération des entrée de business unit sous forme JSON et import dans mongo via mongoimport
(sqlplus -s al/toor@//localhost/pdb1.localdomain <<EOF 
-- on supprime toutes les impressions inutiles
set pagesize 0 
set trimspool on
set headsep off
set null '0'
set echo off
set feedback off
set linesize 1000
clear breaks;
-- requete JSON 
SELECT json_object(
    '_id' VALUE bu.bu_id,
    'name' VALUE bu.bu_name,
    'location' VALUE bu.location,
    'description' VALUE bu.description,
    'manager_first_name' VALUE bu.manager_first_name,
    'manager_last_name' VALUE bu.manager_last_name
    )
FROM BusinessUnit bu;
-- fini !
exit;
EOF
) | mongoimport   --db IOT --collection BusinessUnit  --authenticationDatabase admin --username "root" --password "toor"

(sqlplus -s al/toor@//localhost/pdb1.localdomain <<EOF 
-- on supprime toutes les impressions inutiles
set pagesize 0 
set trimspool on
set headsep off
set null '0'
set echo off
set feedback off
set linesize 1000
clear breaks;
-- requete JSON 
SELECT json_object(
    '_id' VALUE r.robot_id,
    'name' VALUE r.robot_name,
    'buId' VALUE r.bu_id,
    'jobId' VALUE r.job_id
    )
FROM robot r;
-- fini !
exit;
EOF
) | mongoimport --db IOT --collection Robot --authenticationDatabase admin --username "root" --password "toor"

(sqlplus -s al/toor@//localhost/pdb1.localdomain <<EOF 
-- on supprime toutes les impressions inutiles
set pagesize 0 
set trimspool on
set headsep off
set null '0'
set echo off
set feedback off
set linesize 1000
clear breaks;
-- requete JSON 
SELECT json_object(
    '_id' VALUE j.job_id,
    'name' VALUE j.job_name,
    'description' VALUE j.description
    )
FROM job j;
-- fini !
exit;
EOF
) | mongoimport --db IOT --collection Job --authenticationDatabase admin --username "root" --password "toor"



mongosh --authenticationDatabase admin -u "root" -p "toor" <<EOF
use IOT
db.Robot.aggregate([
  { "$lookup": {
    "from": 'Job',
    "let": { "jid": "$jobId" },
    "pipeline": [
      { "$match": { "$expr": { "$eq": [ "$_id", "$$jid" ] } } },
    ],
    "as": "jobs",
      }
  }
])
exit;
EOF
