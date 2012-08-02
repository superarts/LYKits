#!/usr/bin/php
<?php

require('lib/lykits.php');
//	$arg = arg_parse($argv);

if ($argc <= 1)
{
	echo "USAGE: {$argv[0]} PACKAGE_NAME FILENAME_README FILENAME_ICON\n";
	echo "default icon and readme:\n";
	echo "	~/icon.png\n";
	echo "	~/README.txt\n";
	echo "		FEED_URL\n";
	echo "		TITLE\n";
	echo "		SHORT_DESCRIPTION\n";
	echo "		LONG_DESCRIPTION\n";
}

$package_name = $argv[1];
if (isset($argv[2]))
	$filename_readme = $argv[2];
else
	$filename_readme = '~/README.txt';
if (isset($argv[3]))
	$filename_icon = $argv[3];
else
	$filename_icon = '~/icon.png';

$readme = file($filename_readme);

?>
