#!/usr/bin/php
<?php

exec("ls", $r);
print_r($r);
mkdir("ver1024");
foreach ($r as $s)
{
	$s = "convert \"$s\" -resize 1024x1024 \"ver1024/$s\"";
	echo "$s\n";
	system($s);
}

?>
