<?php
echo nl2br("Xdebug Test\n");

$foo = 'foo';
var_dump($foo);

$numbers = [1, 2, 3, 4];
print_r($numbers);

$sum = array_sum($numbers);
var_dump($sum);

$double = array_map(fn ($value): int => $value * 2, $numbers);
print_r($double);

$cube = array_map('cube', $numbers);
print_r($cube);

function cube(int $num): int
{
    return ($num * $num * $num);
}
