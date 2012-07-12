#!/usr/bin/php
<?php

exec("ls *a.png", $a);
//	echo "ls $argv[1]\n";
//	print_r($a);
foreach ($a as $s)
{
	$exec = "convert $s -resize 512x512 $s";
	echo "$exec\n";
	exec($exec);
}

?>
