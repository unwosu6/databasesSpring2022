DROP PROCEDURE IF EXISTS AllCourseAverages;

DELIMITER //

CREATE PROCEDURE AllCourseAverages(IN pword VARCHAR(15))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE current_sid INT;
    DECLARE sidcur CURSOR FOR SELECT sid FROM HW4_Student ORDER BY sec ASC, lname ASC, fname ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    IF EXISTS(SELECT * FROM HW4_Password WHERE curpasswords = pword) THEN
        OPEN sidcur;
        REPEAT
            FETCH sidcur INTO current_sid;
            CALL ShowPercentages(current_sid); 
        UNTIL done
        END REPEAT;
    END IF;
END;//

DELIMITER ;