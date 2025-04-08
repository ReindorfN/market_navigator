<?php

class Connection{
    private $host = 'localhost';
    private  $dbname = 'market_navigator';
    private $user = 'postgres';
    private $password = ''; // Set your database password here

    public $conn;

    public function getConnection(){
        $this-> conn = null;
        $this-> conn = new mysqli($this->host, $this->dbname, $this->user, $this->password);

        if ($this->conn->connect_error) {
            die("Connection error: " . $this->conn->connect_error);
            
        }
        else{
            // echo "Connection successfull!!";
        }
        mysqli_set_charset($this->conn, "utf8");

        return $this->conn;
    }
}

?>