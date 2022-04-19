echo "<h2>Student ID Raw Scores</h2><br>"
echo "SID: ";

if (!empty($item)) {
    echo $item;
    echo "<br><br>"

    if ($result = $conn->query("CALL ShowRawScores();")) {
        echo "table border = "
    }
}
