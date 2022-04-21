Udochukwu Nwosu unwosu6

Most of my code is simple and works well but I just wanted to show the work I did before I got here
that was not necessary at all but sort of cool (not efficent though). It took me so long to figure out
that I had to turn it in in some capacity lol. We learned about Cursors in class
and I used the slides to make these versions of the ShowAllRawScores files:

------ HW4_ShowAllRawScores.sql ------
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

------ HW4_ShowAllRawScores.php ------
<head><title>All Raw Scores</title></head>
<body>
<?php

	//open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$item = $_POST['password'];

	// echo some basic header info onto the page
	echo "<h2>All Raw Scores</h2><br>";

	// proceed with query only if supplied SID is non-empty
	if (!empty($item)) {
		// call the stored procedure we already defined on dbase
		if ($result = $conn->query("CALL AllRawScores('".$item."');")) {
			
			if ($result->num_rows > 0) {
				echo "<table border=\"2px solid black\">";

				// output a row of table headers
				echo "<tr>";
				// collect an array holding all attribute names in $result
				$flist = $result->fetch_fields();

				foreach($flist as $fname){
					echo "<td>".$fname->name."</td>";
				}
				echo "</tr>";

				// output a row of table for each row in result, using flist names
				// to obtain the appropriate attribute value for each column
				foreach($result as $row){
					// reset the attribute names array
					$flist = $result->fetch_fields(); 
					echo "<tr>";
					foreach($flist as $fname){
					echo "<td>".$row[$fname->name]."</td>";
					}
					echo "</tr>";
				}
				echo "</table>";
			} else {
				echo "ERROR: Invalid password";
			}
			echo "<br>";
		} else {
			echo "Call to AllRawScores failed<br>";
		}
	}
	// close the connection opened by open.php
	$conn->close();
?>
</body>