<?php
  define('SECRET', '25fab666');
  define('FLAG', 'FLAG:180e2300112ef5a4f23c93cfdec8d780');

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
