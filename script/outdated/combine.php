#!/usr/bin/php
<?php

$name = $argv[1];
$count = $argv[2];

$s = 'cat ';
for ($i = 1; $i <= $count; $i++)
	$s .= $name . '.' . str_pad($i, 3, '0', STR_PAD_LEFT) . ' ';
$s .= "> $name";
echo "$s\nProcessing...\n";
exec($s);

?>
