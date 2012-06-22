#!/usr/bin/php
<?php

if ($argc <= 1)
{
	echo "usage: {$argv[0]} ...\n";
	echo "	d	hp armor_reduction resistance_reduction - defense: the larger the better\n";
	die;
}

switch (strtolower($argv[1]))
{
case 'd':
	$hp = $argv[2];
	$ar = $argv[3];
	$rr = $argv[4];
	$def = $hp / (100 - $ar) / (100 - $rr);
	echo "defense: $def\n";
	break;
default:
	echo "unknown command\n";
}
