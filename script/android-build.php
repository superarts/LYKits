#!/usr/bin/php
<?php

function exec_command($cmd, $test = false)
{
	if ($test)
		echo "$cmd\n";
	else
	{
		echo "====\n$cmd\n====\n";
		system($cmd);
	}
}

if ($argc < 4)
{
	echo "usage:\n\t{$argv[0]} DIRECTORY FILENAME VERSION\n";
	echo "example:\n\t{$argv[0]} security AntivirusSecurity 1.0\n";
	die;
}
$dir	= $argv[1];
$name	= $argv[2];
$ver	= $argv[3];		//	TODO: get version from manifest

$aid = file_get_contents("$dir/assets/aid.txt");
echo "current aid: $aid\n";
$cwd = getcwd();
echo "current path: $cwd\n";

$aid_list = file("$dir/assets/aid_list.txt");
foreach ($aid_list as $aid)
{
	$aid = substr($aid, 0, -1);
	file_put_contents("$dir/assets/aid.txt", $aid);
	/*
	$fp = fopen("$dir/assets/aid.txt", 'wb');
	fwrite($fp, $aid);
	fclose($fp);
	 */
	chdir("$dir");
	//exec_command("cd $dir ; ant debug ; cd ..");
	exec_command("ant clean");
	exec_command("ant debug");
	chdir("$cwd");
	exec_command("cp $dir/bin/*-debug.apk tags/$name/{$name}_{$ver}_{$aid}.apk");
}

?>
