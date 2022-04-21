DROP PROCEDURE IF EXISTS AllCourseAverages;

DELIMITER //

CREATE PROCEDURE AllCourseAverages(IN pword VARCHAR(15))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Password AS P WHERE P.curpasswords = pword) THEN
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
        SET @sql = CONCAT('SELECT S.sid, S.lname, S.fname, S.sec ',
                        ', CAST(IFNULL(40*(SELECT sum(RS.score)/sum(A.ptsposs) FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname = RS.aname WHERE A.atype = ''QUIZ'' AND RS.sid = S.sid),0) + ',
                        '60*(SELECT sum(RS.score)/sum(A.ptsposs) FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname = RS.aname WHERE A.atype = ''EXAM'' AND RS.sid = S.sid) AS DECIMAL(5,2)) as courseAvg ',
                        'FROM HW4_Student AS S JOIN HW4_RawScore AS RS ON S.sid = RS.sid JOIN HW4_Assignment AS A ON A.aname = RS.aname ',
                        'GROUP BY S.sid ORDER BY S.sec ASC, courseAvg DESC');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END;//

DELIMITER ;