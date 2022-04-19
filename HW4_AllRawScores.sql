-- If given any valid password present in the HW4 passwords table, display a
-- table showing the raw scores for all students in the course, sorted in ascending order by section
-- number, then last name and finally first name. The display order within a given row and the
-- column headers in the table should match that outlined in problem 1 above. If the supplied
-- password is not present in the table, the PHP script should not display any table, but should
-- instead display the descriptive message ”ERROR: Invalid password”. Use the filenames
-- HW4 ShowAllRawScores.sql and HW4 ShowAllRawScores.php for this item

DROP PROCEDURE IF EXISTS AllRawScores;

DELIMITER //

CREATE PROCEDURE ShowRawScores(IN pword VARCHAR(15))

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