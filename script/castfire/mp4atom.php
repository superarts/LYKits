#!/usr/bin/php
<?php

echo "Usage: mp4atom.php FILENAME\n";

if ($argc == 1)
	die(0);
$filename = $argv[1];

if ($argc == 2)
	$offset = 0;
else
	$offset = $argv[2] + 0;

echo "$argc: $filename at $offset\n";

function str_to_int_le($str, $count = 4)	//	small endian
{
	global $videoDebug;
	$result = 0;

	for ($i = 0; $i < $count; $i++)
	{
		$b[$i] = ord($str{$i});
		$b[$i] = ord($str{$i});
		$b[$i] = ord($str{$i});
		$b[$i] = ord($str{$i});
	}

	//	if ($videoDebug) echo "str to int: $b1, $b2, $b3, $b4\n";
	for ($i = 0; $i < $count; $i++)
	{
		$result += $b[$i] * pow(256, $count - 1 - $i);
	}
	//	$result = $b4 + $b3 * 256 + $b2 * 256 * 256 + $b1 * 256 * 256 * 256;

	return $result;
}

function read_qt_atom($fp)
{
	global $nest;

	/*
	if ($nest == 9)
		return true;
	 */

	$pos = ftell($fp);
	echo $pos;

	for ($i = 0; $i < $nest; $i++)
		echo "  ";

	//$reserved = fread($fp, 10);
	//$lock_count = fread($fp, 2);

	$size = fread($fp, 4);
	$type = fread($fp, 4);
	$atom_id = fread($fp, 4);
	$reserved = fread($fp, 2);
	$child_count = fread($fp, 2);
	$reserved = fread($fp, 4);

	$size = str_to_int_le($size);
	$atom_id = str_to_int_le($atom_id);
	$child_count = str_to_int_le($child_count, 2);
	echo "$type - size: $size, atom id: $atom_id, child count: $child_count\n";

	if (str_to_int_le($type) < 10000)
	{
		fseek($fp, $size - 0x14, SEEK_CUR);
		return false;
	}

	if ($child_count == 0)
	{
		fseek($fp, $size - 0x14, SEEK_CUR);
		return true;
	}

	for ($i = 0; $i < $child_count; $i++)
	{
		$nest++;
		if (read_qt_atom($fp) == false)
			$i--;
		$nest--;
	}
}

function read_atom($fp)
{
	global $argv;

	echo ftell($fp) , "\n";
	if (ftell($fp) > filesize($argv[1]))
	//	if (ftell($fp) == 12417)
		return;

	$length = fread($fp, 4);
	$length = str_to_int_le($length);
	$name = fread($fp, 4);
	echo "read $name:$length\n";

	$next = fread($fp, 4);
	$next = str_to_int_le($next);
	fseek($fp, -4, SEEK_CUR);

	if (
		//($name == 'ftyp') ||
		($name == 'moov') ||
		//($name == 'mvhd') ||
		($name == 'sean') ||
		($name == 'evnt') ||
		($name == 'actn') ||
		($name == 'mdat')
	)
	{
		if (($length == 0) and ($name == 'mdat'))
		{
			echo "wrong mdat deteced\n";
			fseek($fp, 12, SEEK_CUR);
		}
		read_atom($fp);
	}
	else
	{
		echo "skipped\n";
		if ($length > 0)
		{
			fseek($fp, $length - 8, SEEK_CUR);
			read_atom($fp);
		}
		else
		{
			return;
		}
	}
	/*
	if ($next > 0x3000)
	{
		echo "skipped\n";
		fseek($fp, $length - 8, SEEK_CUR);
	}
	else
	{
		read_atom($fp);
	}
	 */
	//	return $length;
}

$fp = fopen($filename, "rb");

fseek($fp, $offset);
$nest = 0;
read_qt_atom($fp);

fclose($fp);

?>
