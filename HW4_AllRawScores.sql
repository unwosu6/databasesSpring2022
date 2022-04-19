DROP PROCEDURE IF EXISTS AllRawScores;

DELIMITER //

CREATE PROCEDURE AllRawScores(IN pword VARCHAR(15))
    -- IF EXISTS(SELECT * FROM HW4_PASSWORD WHERE curpasswords = pword) THEN
BEGIN
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

        SET @sql = CONCAT('SELECT S.sid, S.lname, S.fname ',
                         @sql,
                         'FROM HW4_Student AS S JOIN HW4_RawScore AS RS ON RS.sid = S.sid');

        -- SET @sql = CONCAT('SELECT S.sid, S.lname, S.fname ',
        --                  @sql,
        --                  'FROM HW4_Student AS S JOIN HW4_RawScore AS RS ON RS.sid = S.sid ',
        --                  'ORDER BY S.sid ASC, S.lname ASC, S.fname ASC');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
END;//

        -- SET @sql = CONCAT('SELECT S.sid, S.lname, S.fname',
        --                 @sql,
        --                 'FROM HW4_Student AS S, HW4_RawScore AS RS, HW4_Assignment AS A ON RS.aname = A.aname AND RS.sid = S.sid',
        --                 'ORDER BY S.sid ASC, S.lname ASC, S.fname ASC');
        -- PREPARE stmt FROM @sql;
        -- DEALLOCATE PREPARE stmt;
        --END IF;
-- END;//

DELIMITER ;