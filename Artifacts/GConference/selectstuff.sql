-- First dig
SELECT logdate, process, severity, count(*) AS occurence
  FROM gconference.sp2013_logs_indexed
 GROUP BY logdate, process, severity
 ORDER BY logdate DESC, occurence DESC;
 
 -- Refined dig
SELECT severity, process, area, category, message
  FROM gconference.sp2013_logs_indexed
 WHERE process LIKE 'w3wp.exe%'
   AND severity IN ('Unexpected', 'High', 'Critical')