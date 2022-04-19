DROP PROCEDURE IF EXISTS ShowRawScores;

DELIMITER //

CREATE PROCEDURE ShowRawScores(IN sid VARCHAR(10))

BEGIN
    SET @sql = NULL;
    SELECT
        GROUP_CONCAT(DISTINCT
            CONCAT(
                'max(case when aname = ''',
                aname,
                ''' then score end) as ''',
                aname,
                ''''
            )
            ORDER BY atype DESC, aname ASC
        ) INTO @sql
        FROM HW4_Assignment;

        SET @sql = CONCAT('SELECT sid, ',
                         @sql,
                         'FROM HW4_RawScore WHERE sid = ',
                         '?');
        PREPARE stmt FROM @sql;
        EXECUTE stmt USING sid;
        DEALLOCATE PREPARE stmt;
END;//

DELIMITER ;