#!/usr/bin/php
<?

require('lib/lykits.php');
$arg = arg_parse($argv);
//	print_r($arg);

if ($argc <= 1)
{
	echo "OPTIONS\n";
	echo "	-p	set path of AndroidManifest.xml\n";
	echo "	-n	set package name\n";
	echo "	-v	set version name\n";
	echo "	-c	set version code\n";
	echo "	-a	add permission, e.g. update (auto update & tracking)\n";
	echo "COMMANDS\n";
	echo "	?		print manifest info\n";
	echo "	run/r		try to launch the app\n";
	echo "	uninst/u	try to uninstall the app\n";
	echo "	nobackup	no backup\n";
	echo "	launcher	get launcher filename\n";
	echo "	pid			get package name\n";
	echo "	svn		use svn commands for file operations like mkdir, mv, etc.\n";
	echo "	git		use git commands for file operations like mkdir, mv, etc.\n";
}

if (isset($arg['opt']['p']))
	$path = $arg['opt']['p'] . '/';
else
	$path = '';

$filename = $path . 'AndroidManifest.xml';
$content = file_get_contents($filename);
if ($content === false)
{
	echo "file not found: $filename\n";
	die;
}
$header_manifest = str_get_between($content, '<manifest', '>');
$pid = str_get_between($header_manifest, 'package="', '"');
$version_code = str_get_between($header_manifest, 'android:versionCode="', '"');
$version_name = str_get_between($header_manifest, 'android:versionName="', '"');

$header_launcher = str_get_between($content, '<activity', 'android.intent.category.LAUNCHER', 'reverse');
$activity_launcher = str_get_between($header_launcher, 'android:name="', '"');

if (in_array('?', $arg['arg']))
{
	echo "package id: $pid\n";
	echo "version code: $version_code\n";
	echo "version name: $version_name\n";
	echo "launcher activity: $activity_launcher\n";
}

if ((in_array('run', $arg['arg'])) or (in_array('r', $arg['arg'])))
{
	$cmd = "adb shell am start -n $pid/$activity_launcher";
	echo "$cmd\n";
	exec($cmd);
}

if ((in_array('uninstall', $arg['arg'])) or (in_array('u', $arg['arg'])))
{
	$cmd = "adb uninstall $pid";
	echo "$cmd\n";
	exec($cmd);
}

if (in_array('svn', $arg['arg']))
{
	$cmd_mkdir = 'svn mkdir --parents';
	$cmd_mv = 'svn move';
}
else if (in_array('git', $arg['arg']))
{
	$cmd_mkdir = 'mkdir -p';
	$cmd_mv = 'git mv';
}
else
{
	$cmd_mkdir = 'mkdir -p';
	$cmd_mv = 'mv';
}

if (in_array('launcher', $arg['arg']))
{
	$s = str_replace('.', '/', $activity_launcher);
	$s = $path . "src/$s.java";
	if (!file_exists($s))
	{
		$s = "$pid.$activity_launcher";
		$s = str_replace('.', '/', $s);
		$s = $path . "src/$s.java";
	}
	//	TODO: what if the file is still not there?
	if (file_exists($s))
		echo $s;
}

if (in_array('pid', $arg['arg']))
{
	echo $pid;
}

$content_new = $content;
if (isset($arg['opt']['n']))
{
	$s = $arg['opt']['n'];
	$s = str_replace_between($header_manifest, 'package="', '"', $s);
	$header_manifest = $s;
	$s = str_replace_between($content_new, '<manifest', '>', $s);
	//	echo "$s\n";
	$content_new = $s;
}

if (isset($arg['opt']['v']))
{
	$s = $arg['opt']['v'];
	$s = str_replace_between($header_manifest, 'android:versionName="', '"', $s);
	$header_manifest = $s;
	$s = str_replace_between($content_new, '<manifest', '>', $s);
	//	echo "$s\n";
	$content_new = $s;
}

if (isset($arg['opt']['c']))
{
	$s = $arg['opt']['c'];
	$s = str_replace_between($header_manifest, 'android:versionCode="', '"', $s);
	$header_manifest = $s;
	$s = str_replace_between($content_new, '<manifest', '>', $s);
	//	echo "$s\n";
	$content_new = $s;
}

function get_permission($manifest, $permission)
{
	if (strpos($manifest, $permission) === false)
		return "<uses-permission android:name=\"android.permission.$permission\" />\n";
	return '';
}

if (isset($arg['opt']['a']))
{
	$permissions = "\n";
	switch ($arg['opt']['a'])
	{
	case 'update':
		$permissions .= get_permission($content_new, 'INTERNET');
		$permissions .= get_permission($content_new, 'READ_PHONE_STATE');
		$permissions .= get_permission($content_new, 'ACCESS_NETWORK_STATE');
		$permissions .= get_permission($content_new, 'WRITE_EXTERNAL_STORAGE');
		$header_permission = str_get_between($content_new, '<manifest', 'uses-sdk');
		$header_permission = str_insert_between($header_permission, '>', '<', $permissions);
		$content_new = str_replace_between($content_new, '<manifest', 'uses-sdk', $header_permission);
		break;
	}
}

$test = false;
$timestamp = date_timestamp();
if ($content != $content_new)
{
	if ($test)
		echo "new content: $content_new\n";
	else
		file_put_contents($filename, $content_new);
	if (!in_array('nobackup', $arg['arg']))
	{
		$filename_backup = "_$filename.$timestamp.backup";
		echo "creating backup: $filename_backup\n";
		file_put_contents($filename_backup, $content);
	}
}

/*
	change file path
 */
if (isset($arg['opt']['n']))
{
	$pid_new = $arg['opt']['n'];
	$path_old = $path . "src/" . str_replace('.', '/', $pid);
	$path_new = $path . "src/" . str_replace('.', '/', $pid_new);
	$cmd = "$cmd_mkdir $path_new";
	echo "$cmd\n";
	system($cmd);
	$cmd = "$cmd_mv $path_old/* $path_new/";
	echo "$cmd\n";
	system($cmd);
	if ($path == '')
		$dest = '.';
	else
		$dest = $path;
	//$cmd = "srpl $dest $pid $pid_new";
	$cmd = "rpl -R $pid $pid_new $dest";
	echo "$cmd\n";
	system($cmd);
}

?>
