<?php
  define('FLAG', 'FLAG:0076ecde2daae415d7e5ccc7db909e7e');

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
