lab start deploy-introduction
oc login -u developer -p developer https://api.ocp4.example.com:6443

cd /home/student/ex288

curl --fail --location \
  "https://raw.githubusercontent.com/anishrana2001/Openshift/main/DO288/V.4.18/devops-wala.tar" \
  --output /home/student/ex288/devops-wala.tar

tar -xf /home/student/ex288/devops-wala.tar
cd /home/student/ex288/devops-wala

git init -b main
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin \
  https://developer:d3v3lop3r@git.ocp4.example.com/developer/devops-wala.git

git add .
git commit -m "Add EX288 practice files"
git push -u origin main
rm -rf /home/student/ex288/devops-wala.tar
rm -rf /home/student/ex288/devops-wala/
oc new-project task77

