<?php

require('/usr/local/lib/liblykits.php');
date_default_timezone_set('Australia/Perth');

function cmd_input($prompt = 'Value')
{
	echo "$prompt: ";
	system('stty echo');
	$ret = trim(fgets(STDIN));
	system('stty echo');
	return $ret;
}

/*
	liblykits example

//	aws
require('/Users/leo/prj/sdk/aws/sdk-1.4.3/sdk-1.4.3/sdk.class.php');
//require('/Users/leo/prj/sdk/aws/sdk-1.5.0.1/sdk-1.5.0.1/sdk.class.php');
define('AWS_KEY', '');
define('AWS_SECRET_KEY', '');

//	gdata
set_include_path('/Users/leo/prj/sdk/zend/library');
require_once 'Zend/Loader.php';
$ly_gdata_username = 'superartstudio@gmail.com';
$ly_gdata_password = '';

 */

//	string

function str_range_between($string, $start, $end, $mode = 'normal')
{
	if ($mode == 'normal')
	{
		//	$string = " " . $string;
		$ini = strpos($string,$start);
		//	echo "index: $ini\n";
		if ($ini === false) return false;
		$ini += strlen($start);
		$len = strpos($string,$end,$ini) - $ini;
		//	echo "length: $len\n";
		if ($len < 0) return false;
		return array('index' => $ini, 'length' => $len);
	}
	else if ($mode == 'reverse')
	{
		$tail = strpos($string, $end);
		if ($tail == 0) return false;
		$head = 0;
		do {
			$head_last = $head;
			$head = strpos($string, $start, $head + 1);
			//	echo "reverse head: $head_last/$head, tail: $tail\n";
		}	while (($head < $tail) && ($head !== false));
		if ($head_last == 0) return false;
		//	echo "reverse last head: $head_last, tail: $tail\n";
		$head_last++;
		if ($tail <= $head_last) return false;
		return array('index' => $head_last, 'length' => $tail - $head_last);
	}
}
function str_get_between($string, $start, $end, $mode = 'normal')
{
	$range = str_range_between($string, $start, $end, $mode);
	if ($range == false)
		return "";
	else
		return substr($string, $range['index'], $range['length']);
}
function str_replace_between($string, $start, $end, $replace, $mode = 'normal')
{
	$range = str_range_between($string, $start, $end, $mode);
	//	print_r($range);
	if ($range == false)
		return $string;
	else
		return substr($string, 0, $range['index']) . $replace . substr($string, $range['index'] + $range['length']);
}
function str_insert_between($string, $start, $end, $insert, $mode = 'normal')
{
	$range = str_range_between($string, $start, $end, $mode);
	//	print_r($range);
	if ($range == false)
		return $string;
	else
		return substr($string, 0, $range['index']) . $insert . substr($string, $range['index']);
}
function str_insert_after($string, $start, $end, $insert, $mode = 'normal')
{
	$range = str_range_between($string, $start, $end, $mode);
	//	print_r($range);
	if ($range == false)
		return $string;
	else
		return substr($string, 0, 
		$range['index'] + $range['length']) . $insert . substr($string, $range['index'] + $range['length']);
}

function str_is_start_with($haystack, $needle)
{
    $length = strlen($needle);
    return (substr($haystack, 0, $length) === $needle);
}

function str_is_end_with($haystack, $needle)
{
    $length = strlen($needle);
    $start  = $length * -1; //negative
    return (substr($haystack, $start) === $needle);
}

function arg_parse($argv)
{
	$a = array();
	$a['cmd'] = $argv[0];
	$a['opt'] = array();
	$a['arg'] = array();
	for ($i = 1; $i < count($argv); $i++)
	{
		$s = $argv[$i];
		if (str_is_start_with($s, '-'))
		{
			$i++;
			$a['opt'][substr($s, 1)] = $argv[$i];
		}
		else
			$a['arg'][] = $s;
	}
	return $a;
}

function date_timestamp()
{
	return date('Ymd.His');
}

?>
