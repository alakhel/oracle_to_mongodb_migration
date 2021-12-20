sudo service mongod start
mongodb://root:*****@127.0.0.1:27017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false

$ mongo
> use reservationSalles; # créé une/se positionne sur base de donnée pour la réservation de salles
> db.createCollection(‘salles’); # créé la collection des salles
> db.createCollection(‘personnes’); # créé la collection des personnes
> db.createCollection(‘reservations’); # créé la collection des reservations
> db.personnes.insert({ nom:"ploix", prenom:"damien", estAbonne:true, numeroAbonne:1}); # premier abonné !
> db.personnes.find( { } );
{ "_id" : ObjectId("5dd15aa26ff79a34fb912909"), "nom" : "ploix", "prenom" : "damien", "estAbonne" : true, "numeroAbonne" : 1 }


SELECT json_object('id' VALUE mgr.employee_id, 
'manager' VALUE (mgr.first_name || ' '|| mgr.last_name),
'numReports' VALUE count(rpt.employee_id),
'reports' VALUE json_arrayagg(rpt.employee_id ORDER BY rpt.employee_id))
FROM employees mgr, employees rpt
WHERE mgr.employee_id = rpt.manager_id
GROUP BY mgr.employee_id, mgr.last_name, mgr.first_name
HAVING count(rpt.employee_id) > 0;


=======
#!/bin/bash
# nétoyage de la collection personnes de la base adresses dans MongoDB
# on considère que la db (HR) et la collection (managers) existe déjà
mongo <<EOF
use HR
db.managers.remove({});
exit;
EOF
# base de données Oracle : pdb1
# utilisateur : HR, mot de passe HR
# récupération des managers et de leurs employés sous forme JSON et import dans mongo via mongoimport
(sqlplus -s HR/HR@//localhost/pdb1.localdomain <<EOF 
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
SELECT json_object('id' VALUE mgr.employee_id,
'manager' VALUE (mgr.first_name || ' '|| mgr.last_name),
'numReports' VALUE count(rpt.employee_id),
'reports' VALUE json_arrayagg(rpt.employee_id ORDER BY rpt.employee_id))
FROM employees mgr, employees rpt
WHERE mgr.employee_id = rpt.manager_id
GROUP BY mgr.employee_id, mgr.last_name, mgr.first_name
HAVING count(rpt.employee_id) > 0;
-- fini !
exit;
EOF
) | mongoimport --db HR --collection managers




db.products.insert(
   [
     { _id: 11, item: "pencil", qty: 50, type: "no.2" },
     { item: "pen", qty: 20 },
     { item: "eraser", qty: 25 }
   ]
)
{ "_id" : 11, "item" : "pencil", "qty" : 50, "type" : "no.2" }
{ "_id" : ObjectId("51e0373c6f35bd826f47e9a0"), "item" : "pen", "qty" : 20 }
{ "_id" : ObjectId("51e0373c6f35bd826f47e9a1"), "item" : "eraser", "qty" : 25 }





var countryId = Object();
db.country.insert({ _id: countryId, code: 1, name: 'Brasil' });
db.state.insert({ code: 1, name: 'SC', contry : { $ref: 'country', $id: countryId } });