#!/usr/bin/php
<?php

//exec("ls *.caf", $r);
//exec("ls *.aif", $r);
exec("ls *.wav", $r);
//print_r($r);
foreach ($r as $s)
{
	echo "converting $s...\n";
	//exec("afconvert -f caff -d LEI16@44100 -c 1 $s tmp/$s");
	$s = "afconvert -f caff -d LEI16@8000 -c 1 $s " . substr($s, 0, -4) . ".caf";
	//echo "$s\n";
	exec($s);
}

$r = array();

exec("ls *.mp3", $r);
foreach ($r as $s)
{
	echo "converting $s...\n";
	$s = "afconvert -f caff -d LEI16@8000 -c 1 $s " . substr($s, 0, -4) . ".caf";
	exec($s);
}

$r = array();

exec("ls *.aif", $r);
foreach ($r as $s)
{
	echo "converting $s...\n";
	$s = "afconvert -f caff -d LEI16@8000 -c 1 $s " . substr($s, 0, -4) . ".caf";
	exec($s);
}

?>
