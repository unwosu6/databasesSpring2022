DROP PROCEDURE IF EXISTS ShowPercentages;

DELIMITER //

CREATE PROCEDURE ShowPercentages(IN sid VARCHAR(10))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Student AS S WHERE S.sid = sid) THEN
        SET @sql = NULL;
        SELECT
            GROUP_CONCAT(DISTINCT
                CONCAT(
                    'CAST(max(case when A.aname = ''',
                    aname,
                    ''' then 100*RS.score/A.ptsposs end) AS DECIMAL(5,2)) AS ''',
                    aname,
                    ''''
                )
                ORDER BY atype DESC, aname ASC
            ) INTO @sql
        FROM HW4_Assignment;
        SET @sql = CONCAT('SELECT S.sid, S.lname, S.fname, S.sec, ',
                        @sql,
                        ', CAST(IFNULL(40*(select sum(RS.score)/sum(A.ptsposs) from HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname = RS.aname where A.atype = ''QUIZ'' and RS.sid = ?),0) + ',
                        '60*(select sum(RS.score)/sum(A.ptsposs) from HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname = RS.aname where A.atype = ''EXAM'' and RS.sid = ?) AS DECIMAL(5,2)) as courseAvg ',
                        'FROM HW4_Student AS S JOIN HW4_RawScore AS RS ON S.sid = RS.sid JOIN HW4_Assignment AS A ON A.aname = RS.aname ',
                        'WHERE S.sid = ',
                        '?');
        PREPARE stmt FROM @sql;
        EXECUTE stmt USING sid,sid,sid;
        DEALLOCATE PREPARE stmt;
    END IF;
END;//

DELIMITER ;
