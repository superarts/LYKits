#!/usr/bin/php
<?php

echo "Usage: mvbatch.php DIR_NAME PREFIX\n";

//	print_r($argv);
$path = $argv[1];
$prefix = $argv[2];
exec("ls $path*", $r);
//	print_r($r);

$i = 0;
foreach ($r as $filename)
{
	$i++;
	$index = str_pad($i, 3, "0", STR_PAD_LEFT);
	$ext = substr($filename, strlen($filename) - 4, 4);
	$s = "mv $filename $path$prefix$index$ext";
	echo "$i:\t$s\n";
	exec("$s");
}

?>
