<head><title>Raw Score</title></head>
<body>
<?php

ini_set('error_reporting', E_ALL);
ini_set('display_errors', false);
include 'conf.php';
$conn = new mysqli($dbhost,$dbuser,$dbpass,$dbname);

if (mysqli_connect_errno()) {

    echo "Connection failed!";

} else {

    $VAR = $_POST['password'];

    $conn->multi_query("CALL AllRawScores('".$VAR."');"); //use if the procedure will return multiple tables (i.e. if your procedure may run > 1 query during 1 call)

    $result = $conn->store_result(); //set result to the first table that is returned from the procedure

	echo "<h2>All Raw Scores</h2><br>";

    if (!$result) {
        echo "ERROR: Invalid password";
    } else {
		$myrow = $result->fetch_row();
		echo "<table border=\"2px solid black\">";

		// output a row of table headers
		echo "<tr>";
		// collect an array holding all attribute names in $result
		$flist = $result->fetch_fields();
		// output the name of each attribute in flist
		foreach($flist as $fname){
			echo "<td>".$fname->name."</td>";
		}
		echo "</tr>";
		
		do {
			foreach($result as $row){

				// reset the attribute names array
				$flist = $result->fetch_fields(); 
				echo "<tr>";
				foreach($flist as $fname){
				echo "<td>".$row[$fname->name]."</td>";
				}
				echo "</tr>";
			}

			$result->free();
			$conn->next_result();
			$result = $conn->store_result();
			$myrow = $result->fetch_row();

		} while ($conn->more_results());

		echo "</table>\n";
    }
}
?>
</body>