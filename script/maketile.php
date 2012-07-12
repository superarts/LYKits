#!/usr/bin/php
<?php

if ($argc < 5)
{
	echo "Usage:\n\t$argv[0] <filename> <destname> <width> <height>\n";
	die();
}

$source_filename = $argv[1];
$dest_dir = $argv[2];
$original_width = (int)$argv[3];
$original_height = (int)$argv[4];

//	interface
//$source_filename = "test.png";
//$dest_dir = "porn_blowjob";
//$original_width = 11520;
//$original_height = 6560;

//	implementation starts from here...
$clip_size = 256;
$prefix_source = "output";
$prefix_dest = $dest_dir;

$zoom_level = -1;
$i = $clip_size;
//echo "$original_width, $original_height, $i\n";
//echo min($original_width, $original_height);
while ($i < min($original_width, $original_height))
{
	$i *= 2;
	$zoom_level++;
}
//die();
function rename_cropped($original_width, $original_height, $zoom, $prefix_source, $prefix_dest, $clip_size)
{
	$tile_x = ceil($original_width / $clip_size);
	$tile_y = ceil($original_height / $clip_size);
	echo "$zoom: $tile_x x $tile_y\n";

	for ($i = 0; $i < $tile_y; $i++)
	{
		for ($ii = 0; $ii < $tile_x; $ii++)
		{
			$index = $i * $tile_x + $ii;
			$s = "mv $prefix_source-$zoom-$index.png $prefix_dest-$zoom-$i-$ii.png";
			//	$s = "mv $prefix_dest-50-$i-$ii.png $prefix_source-$index.png";
			echo "$s\n";
			system($s);
		}
	}

	return;
}

$filename25 = "25-$source_filename.png";

mkdir($dest_dir);
mkdir("$dest_dir/original");
mkdir("$dest_dir/cropped");

for ($i = 0; $i <= $zoom_level; $i++)
{
	$filename_current = "$i-$source_filename.png";
	$filename_index = $i + 1;
	$filename_next = "$filename_index-$source_filename.png";
	$filename_index = $i - 1;
	$filename_prev = "$filename_index-$source_filename.png";

	//	resize
	if ($i != 0)
	{
		//$s = "convert $source_filename -resize 50% $filename_current";
		$s = "convert $source_filename -resize 50% zoom-$i-$dest_dir.png";
		echo "$s\n";
		system($s);

		//	crop
		$s = "convert -crop {$clip_size}x{$clip_size} zoom-$i-$dest_dir.png $prefix_source-$i.png";
		echo "$s\n";
		system($s);

		$source_filename = "zoom-$i-$dest_dir.png";
	}
	else
	{
		$s = "convert -crop {$clip_size}x{$clip_size} $source_filename $prefix_source-$i.png";
		echo "$s\n";
		system($s);
	}

	//	rename
	rename_cropped($original_width, $original_height, $i, $prefix_source, $prefix_dest, $clip_size);
	$original_width = ceil($original_width / 2);
	$original_height = ceil($original_height / 2);

	//	organize
	mkdir("$dest_dir/cropped/$dest_dir-$i");
	echo "mkdir $dest_dir/cropped/$dest_dir-$i\n";
	$s = "mv $prefix_dest-$i-*.png $dest_dir/cropped/$dest_dir-$i/";
	echo "$s\n";
	system($s);
}

$s = "mv zoom-*.png $dest_dir/original/";
echo "$s\n";
system($s);

echo "zoom level: $zoom_level\n";
die(0);

$s = "convert $filename50 -resize 50% $filename25";
echo "$s\n";
system($s);

//	crop
$s = "convert -crop {$prefix_source}x{$prefix_source} $source_filename $prefix_source-100.png";
echo "$s\n";
system($s);
$s = "convert -crop 256x256 $filename50 $prefix_source-50.png";
echo "$s\n";
system($s);
$s = "convert -crop 256x256 $filename25 $prefix_source-25.png";
echo "$s\n";
system($s);

//	rename
rename_cropped($original_width, $original_height, 100, $prefix_source, $prefix_dest);
$original_width = ceil($original_width / 2);
$original_height = ceil($original_height / 2);
rename_cropped($original_width, $original_height, 50, $prefix_source, $prefix_dest);
$original_width = ceil($original_width / 2);
$original_height = ceil($original_height / 2);
rename_cropped($original_width, $original_height, 25, $prefix_source, $prefix_dest);

//	organize
mkdir($dest_dir);
mkdir("$dest_dir/original");
mkdir("$dest_dir/cropped");
mkdir("$dest_dir/cropped/$dest_dir-100");
mkdir("$dest_dir/cropped/$dest_dir-50");
mkdir("$dest_dir/cropped/$dest_dir-25");
$s = "mv $source_filename $filename50 $filename25 $dest_dir/original/";
echo "$s\n";
system($s);
$s = "mv $prefix_dest-100*.png $dest_dir/cropped/$dest_dir-100/";
echo "$s\n";
system($s);
$s = "mv $prefix_dest-50*.png $dest_dir/cropped/$dest_dir-50/";
echo "$s\n";
system($s);
$s = "mv $prefix_dest-25*.png $dest_dir/cropped/$dest_dir-25/";
echo "$s\n";
system($s);

?>
