#!/usr/bin/php
<?php

//	TODO: extension as argv

exec('ls', $r);
//print_r($r);
$index = 0;
foreach ($r as $s)
{
	$cmd = "mv '$s' $index.jpg";
	echo "$cmd\n";
	exec($cmd);
	$index++;
}

?>
