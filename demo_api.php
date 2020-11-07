<?php

/**
 * @param $response
 * @param bool $err
 * @param array $result
 */
function response($response, $err = false, $result = array())
{
    echo json_encode(array(
        "response" => $response,
        "err" => $err ? 1 : 0,
        "result" => $result
    ), JSON_UNESCAPED_SLASHES);
}


$samples_path = $_SERVER["DOCUMENT_ROOT"] . "/api/samples";
$output = shell_exec("alpr -c eu ${samples_path}/demo.jpg");
//$output = shell_exec("alpr -c eu " . $target_dir);

print_r($output);
echo "<hr>";
$result = explode("-", $output);

$first = array_shift($result);
$ps = explode(" ", $first);
$count = trim($ps[1]);

$arr = array(
    "count" => intval(trim($count)),
    "predictions" => array()
);

foreach ($result as $r) {
    $parts = explode(" ", $r);
    $plate = trim($parts[1]);
    $confidence = trim($parts[3]);
    array_push($arr["predictions"], array(
        "license_plate" => $plate,
        "confidence" => $confidence
    ));
}
response("Result Found", false, $arr);
unlink($target_dir);