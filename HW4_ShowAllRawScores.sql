-- DROP PROCEDURE IF EXISTS AllRawScores;

-- DELIMITER //

-- CREATE PROCEDURE AllRawScores(IN pword VARCHAR(15))
-- BEGIN
--     DECLARE done INT DEFAULT 0;
--     DECLARE current_sid INT;
--     DECLARE sidcur CURSOR FOR SELECT sid FROM HW4_Student ORDER BY sec ASC, lname ASC, fname ASC;
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
--     IF EXISTS(SELECT * FROM HW4_Password WHERE curpasswords = pword) THEN
--         OPEN sidcur;
--         REPEAT
--             FETCH sidcur INTO current_sid;
--             CALL ShowRawScores(current_sid); 
--         UNTIL done
--         END REPEAT;
--     END IF;
-- END;//

-- DELIMITER ;

DROP PROCEDURE IF EXISTS AllRawScores;

DELIMITER //

CREATE PROCEDURE AllRawScores(IN pword VARCHAR(15))

BEGIN
    IF EXISTS(SELECT * FROM HW4_Password AS P WHERE P.curpasswords = pword) THEN
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
                        'FROM HW4_RawScore AS RS JOIN HW4_Student AS S ON RS.sid = S.sid GROUP BY RS.sid ORDER BY S.sec ASC, S.lname ASC, S.fname ASC');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END;//

DELIMITER ;