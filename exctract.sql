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


SELECT 
json_object(
    'id' VALUE mgr.employee_id,
    'manager' VALUE (mgr.first_name || ' '|| mgr.last_name),
    'numReports' VALUE count(rpt.employee_id),
    'reports' VALUE json_arrayagg(rpt.employee_id 
    
    ORDER BY rpt.employee_id)
    
    )

    FROM employees mgr, employees rpt
    WHERE mgr.employee_id = rpt.manager_id
    GROUP BY mgr.employee_id, mgr.last_name, mgr.first_name
    HAVING count(rpt.employee_id) > 0;