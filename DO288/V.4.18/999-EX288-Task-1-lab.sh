lab start deploy-introduction
oc login -u developer -p developer https://api.ocp4.example.com:6443

mkdir -p /home/student/ex288/task1/
cd /home/student/ex288/task1/

mkdir -p apps/task1/helloworld
cd apps/task1/helloworld


cat <<EOF > package.json
{
  "name": "nodejs-helloworld",
  "version": "1.0.0",
  "description": "Hello World!"
  "main": "devopswala.js",
  "scripts": {
    "start": "node devopswala.js"
  },
  "author": "Red Hat Training from Devopswala",
  "license": "ASL",
  "dependencies" {
    "express": "^4.20.0"
  }
}
EOF

cat <<EOF > devopswala.js
const express = require('express');
const app = express();

app.get('/', function (req, res) {
  res.send('Hello World!\n');
});

app.listen(3000,()=>{
 console.log("Devopswala app listening on port 8080");
});
EOF

cd /home/student/ex288/task1/

git init -b main
git checkout -b secure-api
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/task1-nodejs-helloworld.git
git add . ; git commit -m "Add EX288 practice files" ; git push -u origin secure-api
git config --global credential.helper store
echo "https://developer:d3v3lop3r@git.ocp4.example.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
rm -f /home/student/ex288/task1/
