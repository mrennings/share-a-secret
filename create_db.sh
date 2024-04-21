#!/bin/bash

read -p 'MySQL admin user: ' sql_admin_user
read -sp 'MySQL admin password: ' sql_admin_pass
read -p 'DB share-a-secret username: ' db_user
read -sp 'DB share-a-secret password: ' db_pass
read -p 'DB host: ' db_host

mysql -u $sql_admin_user -p$sql_admin_pass -h $db_host -t <<EOF
    CREATE DATABASE IF NOT EXISTS shareasecret DEFAULT CHARSET \`utf8\`;
    CREATE TABLE \`shareasecret\`.\`secrets\` (\`id\` VARCHAR(32) NOT NULL , 
        \`secret\` VARCHAR(1024) NOT NULL , \`timestamp\` TIMESTAMP NOT NULL , 
        PRIMARY KEY (\`id\`(32))) ENGINE = InnoDB;

    CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
    GRANT ALL PRIVILEGES ON shareasecret.* TO \`$db_user\`@\`$db_host\`;
    FLUSH PRIVILEGES;
EOF
[ $? -eq 0 ] && echo "Database created successfully" || echo "Error creating database" 

