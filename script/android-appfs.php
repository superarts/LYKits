#!/usr/bin/php
<?php

if ($argc <= 1)
{
	echo "usage: {$argv[0]} PATH\n";
	die;
}

$pid = exec("manifest.php -p {$argv[1]} pid");
$cmd = "cp {$argv[1]}/bin/*-release.apk bin/appfs-free/store/$pid.apk";
echo "$cmd\n";
exec($cmd);
$cmd = "cp {$argv[1]}/res/drawable/icon.png bin/appfs-free/store/$pid.png";
echo "$cmd\n";
exec($cmd);

?>
