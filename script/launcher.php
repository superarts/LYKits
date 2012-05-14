#!/usr/bin/php
<?php

require('lib/lykits.php');
$arg = arg_parse($argv);
//	print_r($arg);

if (in_array('?', $arg['arg']))
{
	echo "OPTIONS\n";
	echo "	-p	set path of AndroidManifest.xml\n";
	echo "COMMANDS\n";
	echo "	?	print help info\n";
	//echo "	nobackup	no backup\n";
	die;
}

if (isset($arg['opt']['p']))
	$path = "-p {$arg['opt']['p']}";
else
	$path = '';

$filename = exec("manifest.php launcher $path");
echo "filename: $filename\n";
$content = file_get_contents($filename);

$content_new = $content;
if (strpos($content_new, 'au.mpiremedia.shared.AutoUpdateActivity') === false)
{
	$s = "\n\nimport au.mpiremedia.shared.AutoUpdateActivity;\n";
	$content_new = str_insert_after($content_new, 'package', "\n", $s);
	echo "inserted import.\n";
}

if (strpos($content_new, 'activity_update') === false)
{
	$s = "\n
	AutoUpdateActivity activity_update = new AutoUpdateActivity();
	activity_update.app_update(this);
	";
	$content_new = str_insert_after($content_new, 'super.onCreate(', "\n", $s);
	echo "inserted onCreate.\n";
}

$test = false;
$timestamp = date_timestamp();
if ($content_new != $content)
{
	if ($test)
		echo "new content: $content_new\n";
	else
		file_put_contents($filename, $content_new);
	/*
	if (!in_array('nobackup', $arg['arg']))
	{
		$filename_backup = "_$filename.$timestamp.backup";
		echo "creating backup: $filename_backup\n";
		file_put_contents($filename_backup, $content);
	}
	 */
}

?>
