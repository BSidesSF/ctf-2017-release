<?php
  define('SECRET', '25fab666');
  define('FLAG', 'FLAG:06c211f73f4f5ba198c7fb56145b39a2');

  $accts = array(
    'administrator' => 'bmLhVHjius',
    'guest' => 'guest',
  );

  function is_valid($username, $password)
  {
    global $accts;

    return array_key_exists($username, $accts) && $accts[$username] === $password;
  }
?>
