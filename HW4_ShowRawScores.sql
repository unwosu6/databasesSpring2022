DROP PROCEDURE IF EXISTS ShowRawScores;

DELIMITER //

CREATE PROCEDURE ShowRawScores(IN sid VARCHAR(10))

BEGIN
    IF EXISTS(SELECT * FROM HW4_Student AS S WHERE S.sid = sid) THEN
        SET @sql = NULL;
        SELECT
            GROUP_CONCAT(DISTINCT
                CONCAT(
                    'max(case when RS.aname = ''',
                    aname,
                    ''' then RS.score end) as ''',
                    aname,
                    ''''
                )
                ORDER BY atype DESC, aname ASC
            ) INTO @sql
        FROM HW4_Assignment;

            SET @sql = CONCAT('SELECT RS.sid, S.lname, S.fname, S.sec, ',
                            @sql,
                            'FROM HW4_RawScore AS RS JOIN HW4_Student AS S ON RS.sid = S.sid WHERE RS.sid = ',
                            '?');
            PREPARE stmt FROM @sql;
            EXECUTE stmt USING sid;
            DEALLOCATE PREPARE stmt;
    END IF;
END;//

DELIMITER ;