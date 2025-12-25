#!/bin/bash
printf "Country Name:"
read Country
printf "State or Province Name:"
read ST
printf "Locality:"
read locality
printf "Organization Name:"
read OName
printf "MyName:"
read Myname
printf "Common Name:"
read CName
openssl genrsa -out server.key 4096
openssl req -new -key server.key -out server.csr -subj "/C=$Country/ST=$ST/L=$locality/O=$OName/CN=$CName"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
