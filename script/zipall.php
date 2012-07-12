#!/usr/bin/php
<?php

exec("ls", $r);
//	print_r($r);
//	echo count($r);

foreach ($r as $s)
{
	$dest = $s;
	$dest = str_replace('[', '\[', $dest);
	$dest = str_replace(']', '\]', $dest);
	$dest = str_replace('(', '\(', $dest);
	$dest = str_replace(')', '\)', $dest);
	$s = "zip -0 \"archive.$s.zip\" $dest/*";
	exec($s);
	echo "$s\n";
}

?>
