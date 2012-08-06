#!/usr/bin/php
<?php

require('lib/lykits.php');
//	$arg = arg_parse($argv);

if ($argc <= 1)
{
	echo "USAGE: {$argv[0]} PACKAGE_NAME [FILENAME_README FILENAME_ICON]\n";
	echo "default icon and readme:\n";
	echo "	~/icon.png\n";
	echo "	~/README.txt\n";
	echo "		FEED_URL\n";
	echo "		TITLE (app name on home screen)\n";
	echo "		SHORT_DESCRIPTION (title)\n";
	echo "		LONG_DESCRIPTION (description)\n";
	die;
}

$package_name = $argv[1];
if (isset($argv[2]))
	$filename_readme = $argv[2];
else
	$filename_readme = getenv("HOME") . '/README.txt';
if (isset($argv[3]))
	$filename_icon = $argv[3];
else
	$filename_icon = getenv("HOME") . '/icon.png';

$readme = file($filename_readme);

//	print_r($readme);
$app_url	= substr($readme[0], 0, -1);
$app_name	= substr($readme[1], 0, -1);
$app_title	= substr($readme[2], 0, -1);
$app_desc	= substr($readme[3], 0, -1);

function run($cmd)
{
	echo "$cmd\n";
	//system($cmd);
}

//run("android-duplicate-feedreader $package_name");
run("cp -r template-feedgoal $package_name");
run("cd $package_name");
run("ant clean");
run("rm -rf .git*");
run("mv $filename_icon res/drawable/");
run("manifest.php -n $package_name");

run("srpl . todo_app_url \"$app_url\"");
run("srpl . todo_app_name \"$app_name\"");
run("srpl . todo_app_title \"$app_title\"");
run("srpl . todo_app_description \"$app_desc\"");

run("mv $filename_readme ./");
run("ant debug install");

?>
