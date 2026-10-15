oc login -u developer -p developer https://api.ocp4.example.com:6443
mkdir -p /home/student/ex288/template
cd /home/student/ex288/template
wget https://github.com/anishrana2001/Openshift/raw/refs/heads/main/DO288/V.4.18/05-00-cdnweb-frontend-lab.tar
tar xvf /home/student/ex288/template/05-00-cdnweb-frontend-lab.tar
rm -rf /home/student/ex288/template/05-00-cdnweb-frontend-lab.tar
## Creation of git project.
git init -b cdn-v4
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/mycdn.git
git add .
git commit -m "Add EX288 practice files"
git push -u origin cdn-v4
## cleaning the files.
cd /home/student/ex288/
rm -rf /home/student/ex288/template/
### Storing password
git config --global credential.helper store
echo "https://developer:d3v3lop3r@git.ocp4.example.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
