#!/usr/bin/php
<?php

$size = filesize($argv[1]);
$fp = fopen($argv[1], "rb");

$head = (int)$argv[2];
$tail = (int)$argv[3];
$s = fread($fp, $size);

fclose($fp);

echo substr($s, $head, $tail);

?>
