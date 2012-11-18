#!/usr/bin/php
<?php

//	usage: rename.php EXTENSION
$ext = '';
if ($argc <= 1)
	echo "extension set to EMPTY\n";
else
	$ext = '.' . $argv[1];

exec('ls', $r);
//print_r($r);
$index = 0;
foreach ($r as $s)
{
	$cmd = "mv '$s' $index$ext";
	echo "$cmd\n";
	exec($cmd);
	$index++;
}

?>
