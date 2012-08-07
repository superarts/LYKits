#!/usr/bin/php
<?php

if ($argc < 2)
{
	echo "usage: {$argv[0]} 'http://demo.blogspot.com'\n";
	die;
}
$url = $argv[1];
$url = urlencode($url);
$out = "https://www.google.com/reader/public/atom/feed/$url?n=50";
echo "$out\n";
system("echo '$out' | pbcopy");

?>
