DROP PROCEDURE IF EXISTS ShowPercentages;

DELIMITER //

CREATE PROCEDURE ShowPercentages(IN sid VARCHAR(10))
-- max(case when aname = 'anamegiven' then score end) as aname
BEGIN
    SET @sql = NULL;
    SELECT
        GROUP_CONCAT(DISTINCT
            CONCAT(
                'max(case when A.aname = ''',
                aname,
                ''' then RS.score/A.ptsposs end) as ''',
                aname,
                ''''
            )
            ORDER BY atype DESC, aname ASC
        ) INTO @sql
        FROM HW4_Assignment;

        SET @sql = CONCAT('SELECT RS.sid, ',
                         @sql,
                         'FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A ON RS.aname = A.aname WHERE RS.sid = ',
                         '?');
        PREPARE stmt FROM @sql;
        EXECUTE stmt USING sid;
        DEALLOCATE PREPARE stmt;
END;//

DELIMITER ;
