
lab start deploy-introduction
oc login -u developer -p developer https://api.ocp4.example.com:6443
mkdir -p  /home/student/ex288/helm-task/
cd /home/student/ex288/helm-task/
wget https://github.com/anishrana2001/Openshift/raw/refs/heads/main/DO288/V.4.18/static-webserver.tar.gz
tar zxvf static-webserver.tar.gz ; rm -rf static-webserver.tar.gz


git init -b main
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin \
  https://developer:d3v3lop3r@git.ocp4.example.com/developer/devops-wala-helm.git

git add .
git commit -m "Add EX288 helm question"
git push -u origin main
##### Store the git password
git config --global credential.helper store
echo "https://developer:d3v3lop3r@git.ocp4.example.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
######

### Remove the directory.
rm -rf /home/student/ex288/helm-task/
cd /home/student/
### Storing password
git config --global credential.helper store
echo "https://developer:d3v3lop3r@git.ocp4.example.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
