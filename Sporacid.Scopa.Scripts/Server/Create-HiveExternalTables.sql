--------------------------------------------------------------------
-- Environment variables
--------------------------------------------------------------------
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict; 
SET hive.exec.max.dynamic.partitions=50000; 
SET hive.exec.max.dynamic.partitions.pernode=20000;

--------------------------------------------------------------------
-- Indexed SP2013 Logs External Table
--------------------------------------------------------------------
DROP TABLE default.SP2013_Logs;
CREATE EXTERNAL TABLE IF NOT EXISTS default.SP2013_Logs(
    datedesc date,
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
LOCATION '/hive/warehouse/SP2013_Logs';

--------------------------------------------------------------------
-- Indexed IIS Logs External Table
--------------------------------------------------------------------
DROP TABLE default.IIS_Logs
CREATE EXTERNAL TABLE IF NOT EXISTS default.IIS_Logs(
	datedesc date,
	timedesc time,
	serverIPV6Address string,
	method string,
	uriStem string,
	queryString string,
	serverPortNumber int,
	username string
	clientIPV6Address string,
	userAgent string,
	referer string,
	requestStatus int,
	requestSubstatus int,
	win32Status int,
	timeTaken int)
COMMENT 'Aggregates IIS Log files'
PARTITIONNED BY (hostname string COMMENT 'host name index',
                 logdate string COMMENT 'log date entry index')


)
ROW FORMAT DELIMITED
		FIELDS TERMINATED BY '\t'
		COLLECTION ITEMS TERMINATED BY '\002'
		MAP KEYS TERMINATED BY '\003'
STORED AS TEXTFILE
LOCATION '/hive/warehouse/IIS_Logs';

-- Scans for missing partitions and adds them to the hive metastore
msck repair TABLE default.SP2013_Logs;