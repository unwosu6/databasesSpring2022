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
        SET @sql = CONCAT('SELECT S.SID, S.lname, S.fname, S.sec, CAST(40*sum(Q.score)/sum(Q.ptsposs)+60*sum(E.score)/sum(E.ptsposs) AS DECIMAL(5,2)) AS ''wei_avg'' ',
                        'FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A JOIN HW4_Student AS S ON RS.aname = A.aname AND S.sid = RS.sid JOIN ',
                        '(SELECT RS1.sid, RS1.score, A1.ptsposs FROM HW4_RawScore AS RS1 JOIN HW4_Assignment AS A1 ON A1.aname=RS1.aname WHERE A1.atype = ''QUIZ'' GROUP BY RS1.sid) AS Q ON Q.sid = S.sid JOIN ',
                        '(SELECT RS1.sid, RS1.score, A1.ptsposs FROM HW4_RawScore AS RS1 JOIN HW4_Assignment AS A1 ON A1.aname=RS1.aname WHERE A1.atype = ''EXAM'' GROUP BY RS1.sid) AS E ON Q.sid = E.sid ',
                        'GROUP BY RS.sid ORDER BY S.sec ASC, wei_avg DESC');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END;//

DELIMITER ;