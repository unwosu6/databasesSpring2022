DROP PROCEDURE IF EXISTS ShowPercentages;

DELIMITER //

CREATE PROCEDURE ShowPercentages(IN sid VARCHAR(10))
BEGIN
    SET @sql = NULL;
    SET @sql2 = NULL;
    SELECT
        GROUP_CONCAT(DISTINCT
            CONCAT(
                'max(case when A.aname = ''',
                aname,
                ''' then 100*RS.score/A.ptsposs end) as ''',
                aname,
                ''''
            )
            ORDER BY atype DESC, aname ASC
        ) INTO @sql
    FROM HW4_Assignment;

    SELECT
        GROUP_CONCAT(DISTINCT
            CONCAT(
                '40*sum(Q.score)/sum(Q.ptsposs)+60*sum(E.score)/sum(E.ptsposs) AS ''wei_avg'' FROM (SELECT RS.score, A.ptsposs FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname=RS.aname WHERE A.atype = ''QUIZ'' AND RS.sid = ?) AS Q, (SELECT RS.score, A.ptsposs FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A ON A.aname=RS.aname WHERE A.atype = ''EXAM'' AND RS.sid = ?) AS E, '
            )
        ) INTO @sql2
    FROM HW4_Assignment;

        SET @sql = CONCAT('SELECT RS.sid, S.lname, S.fname, S.sec, 40*sum(Q.score)/sum(Q.ptsposs)+60*sum(E.score)/sum(E.ptsposs) AS ''wei_avg'', ',
                         @sql,
                         'FROM HW4_RawScore AS RS JOIN HW4_Assignment AS A JOIN HW4_Student AS S ON RS.aname = A.aname AND S.sid = RS.sid, (SELECT RS1.score, A1.ptsposs FROM HW4_RawScore AS RS1 JOIN HW4_Assignment AS A1 ON A1.aname=RS1.aname WHERE A1.atype = ''QUIZ'' AND RS1.sid = ?) AS Q, (SELECT RS1.score, A1.ptsposs FROM HW4_RawScore AS RS1 JOIN HW4_Assignment AS A1 ON A1.aname=RS1.aname WHERE A1.atype = ''EXAM'' AND RS1.sid = ?) AS E WHERE RS.sid = ',
                         '?');
        PREPARE stmt FROM @sql;
        EXECUTE stmt USING sid,sid,sid;
        DEALLOCATE PREPARE stmt;
END;//

DELIMITER ;
