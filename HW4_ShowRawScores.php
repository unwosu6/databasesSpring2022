<head><title>Raw Score</title</head>
<body>
<?php
    include 'open.php';
    $item = $_POST['SID'];
    echo "<h2>Student ID Raw Scores</h2><br>"
    echo "SID: ";

    if (!empty($item)) {
        echo $item;
        echo "<br><br>";

        if ($result = $conn->query("CALL ShowRawScores('" .$item. "');")) {
            echo "table border = \"2px solid black\">";
            // row of headers
            echo "<tr>";
            $flist = $result->fetch_fields();
            foreach($flist as $fname){
                echo "<td>".$fname->name."</td>";
            }
            foreach($result as $row){
                $flist = $result->fetch_fields();
                echo "<tr>";
                foreach($flist as $fname){
                    echo "<td>".$row[$fname->name]."</td>";
                }
                echo "</tr>"
            }
            echo "</table>";
        } else {
            echo "Call to ShowRawScores failed<br>";
        }
    }
    $conn->close()
?>
</body>
