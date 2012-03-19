#!/usr/bin/php
<?php

if ($argc == 1)
	die("Usage:\n\t{$argv[0]} FILENAME.txt\n");

$a = file($argv[1]);
$array = array();
$item = '';
foreach ($a as $s)
{
	$s = substr($s, 0, -1);
	if ($s != '')
		$item .= "$s\n";
	else
	{
		$array[] = $item;
		$item = '';
	}
	//	echo "$s\n";
}
sort($array);
//print_r($array);
foreach ($array as $s)
	echo "$s\n";

?>
