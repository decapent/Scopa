CREATE DATABASE IF NOT EXISTS gconference;

--------------------------------------------------------------------
-- SP2013 Logs External Table
--------------------------------------------------------------------
DROP TABLE gconference.SP2013_Logs_Indexed;
CREATE EXTERNAL TABLE IF NOT EXISTS gconference.SP2013_Logs_Indexed(
    datedesc string,
    process string,
    threadId string,
    area string,
    category string,
    eventId string,
    severity string,
    message string,
    correlation string)
COMMENT 'Aggregates SharePoint 2013 Log files'
PARTITIONED BY (hostname string COMMENT 'host name index',
                logdate string COMMENT 'log date entry index')
ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY '\002'
        MAP KEYS TERMINATED BY '\003'
STORED AS TEXTFILE
LOCATION '/hive/warehouse/SP2013_Logs_Indexed';

--------------------------------------------------------------------
-- Indexed IIS Logs External Table
--------------------------------------------------------------------
DROP TABLE gconference.SP2013_Logs_NotIndexed;
CREATE EXTERNAL TABLE IF NOT EXISTS gconference.SP2013_Logs_NotIndexed(
    datedesc string,
    process string,
    threadId string,
    area string,
    category string,
    eventId string,
    severity string,
    message string,
    correlation string)
COMMENT 'Aggregates SharePoint 2013 Log files'
ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY '\002'
        MAP KEYS TERMINATED BY '\003'
STORED AS TEXTFILE
LOCATION '/hive/warehouse/SP2013_Logs_NotIndexed';

-- Scans for missing partitions and adds them to the hive metastore
msck repair TABLE gconference.SP2013_Logs_Indexed;
msck repair TABLE gconference.SP2013_Logs_NotIndexed;


-- First dig
SELECT logdate, process, severity, count(*) AS occurence
  FROM gconference.sp2013_logs_indexed
 GROUP BY logdate, process, severity
 ORDER BY logdate DESC, occurence DESC;