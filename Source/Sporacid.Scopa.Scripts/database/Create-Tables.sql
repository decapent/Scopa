-------------------------------------------------------------------------
-- SP2013 Logs
-------------------------------------------------------------------------
CREATE EXTERNAL TABLE IF NOT EXISTS default.SP2013Logs(logdate date,
       process string,
       threadId string,
       area string,
       category string,
       eventId string,
       severity string,
       message string,
       correlation string)
COMMENT 'Log files from SharePoint 2013'
ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY '\002'
        MAP KEYS TERMINATED BY '\003'
STORED AS TEXTFILE
LOCATION '/hive/warehouse/SP2013Logs'

--------------------------------------------------------------------
-- Indexed SP2013 Logs
--------------------------------------------------------------------
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
PARTITIONED BY (MachineName string COMMENT 'Machine name index',
       LogDate string COMMENT 'Log Date entry index')
ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY '\002'
        MAP KEYS TERMINATED BY '\003'
STORED AS TEXTFILE
LOCATION '/hive/warehouse/SP2013_Logs'

-- Machine name partition
ALTER TABLE SP2013_Logs ADD PARTITION(MachineName='VMSPPLAV');
ALTER TABLE SP2013_Logs ADD PARTITION(MachineName='DESJ-CONTENT');

-- Log Date partition
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151125');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151126');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151127');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151128');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151129');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151130');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151201');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151202');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151203');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151204');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151205');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151206');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151207');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151208');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151209');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151210');
ALTER TABLE SP2013_Logs ADD PARTITION(LogDate='20151211');
