#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo '<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        body { background-color: #0000FF; } /* Sets background to blue */
        h1 { color: white; text-align: center; }
        p { color: white; text-align: center; }
    </style>
</head>
<body>
    <h1>Welcome to the Blue Server!</h1>
    <p>This is a blue-themed page served from $(hostname -f).</p>
</body>
</html>' | sudo tee /var/www/html/index.html > /dev/null