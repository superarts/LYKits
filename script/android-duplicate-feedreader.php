#!/usr/bin/php
<?php

require('lib/lykits.php');
$arg = arg_parse($argv);

if (in_array('?', $arg['arg']))
{
	echo "USAGE: {$argv[0]} [LOCATION_README LOCATION_ICON]\n";
	echo "default icon and readme:\n";
	echo "	~/icon.png\n";
	echo "	~/README.txt\n";
	echo "		PACKAGE_NAME\n";
	echo "		FEED_URL\n";
	echo "		TITLE (app name on home screen)\n";
	echo "		SHORT_DESCRIPTION (title)\n";
	echo "		LONG_DESCRIPTION (description)\n";
	die;
}

if (isset($argv[1]))
	$filename_readme = $argv[1];
else
	$filename_readme = getenv("HOME") . '/README.txt';
if (isset($argv[2]))
	$filename_icon = $argv[2];
else
	$filename_icon = getenv("HOME") . '/icon.png';

$readme = file($filename_readme);

//	print_r($readme);
$package_name = substr($readme[0], 0, -1);
$app_url	= substr($readme[1], 0, -1);
$app_name	= substr($readme[2], 0, -1);
$app_title	= substr($readme[3], 0, -1);
$app_desc	= substr($readme[4], 0, -1);

function run($cmd)
{
	echo "----\n$cmd\n----\n\n";
	exec($cmd);
}

//run("android-duplicate-feedreader $package_name");
run("cp -r template-feedgoal $package_name");
chdir($package_name);
//run("cd $package_name");
run("ant clean");
run("rm -rf .git*");
run("cp $filename_icon res/drawable/");
run("manifest.php -n $package_name");

$app_url = str_replace('/', '\/', $app_url);
run("srpl . todo_app_url \"$app_url\"");
run("srpl . todo_app_name \"$app_name\"");
run("srpl . todo_app_title \"$app_title\"");
run("srpl . todo_app_description \"$app_desc\"");

//run("convert -size 72x72 xc:gray50 -alpha set badge_mask.png -compose DstIn -composite badge_shading.png -compose Over -composite badge_lighting.png");
run("convert res/drawable/icon.png -resize 72x72 res/drawable/icon.png");
run("convert res/drawable/icon.png -alpha set -gravity center -extent 72x72 \
          ~/bin/script/pic/badge_lighting.png \
          \( -clone 0,1 -alpha Opaque -compose Hardlight -composite \) \
          -delete 0 -compose In -composite \
          res/drawable/icon.png");
run("ant debug install");
run("manifest.php run");
//run("cp bin/*-release.apk ~/$package_name.apk");
run("cp $filename_readme ./");
echo "==== README ====\n";
system("cat $filename_readme");

?>
