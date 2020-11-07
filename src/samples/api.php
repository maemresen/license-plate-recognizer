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

if (!isset($_FILES["uploadFile"])) {
    response("File Not Found", true);
    exit;
}


/*------------------------------------
 * Uploaded Image Handler
 ------------------------------------*/

# detecting content of the file
$uploadedFile = $_FILES["uploadFile"]["tmp_name"];
$detectedType = exif_imagetype($uploadedFile);
$name = md5(uniqid());
switch ($detectedType) {
    case IMAGETYPE_JPEG:
        $name .= ".jpg";
        break;
    case IMAGETYPE_PNG:
        $name .= ".png";
        break;
    default:
        response("File Format Not Supported", true);
        exit;
}

# move file to temporary location
$target_dir = $_SERVER["CONTEXT_DOCUMENT_ROOT"] . "/api/uploads";
$target_dir = $target_dir . "/" . $name;

if (!move_uploaded_file($uploadedFile, $target_dir)) {
    response("Sorry, there was an error uploading your file", true);
    exit;
}

/*------------------------------------
 * OpenALPR Part
 ------------------------------------*/

# processing
$output = shell_exec("alpr -c eu " . $target_dir);

# parsing result
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

# delete file
if (isset($_GET["del"]) && $_GET["del"]) {
    unlink($target_dir);
}

if (isset($_GET["del"])) {
    echo "will be dleeeted";
    response("Result Found", false, $arr);
}


