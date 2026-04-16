
### Create a Lab for this question. Chapter 5: User and Resource Management
```
oc login -u admin -p redhatocp  https://api.ocp4.example.com:6443
oc -n openshift-config get secrets htpasswd-secret -o json | jq -r '.data.htpasswd' | base64 --decode > /tmp/htpasswd-ex267.text
htpasswd -b /tmp/htpasswd-ex267.text suraj anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text rajan anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text punit anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text raja anishrana2001
oc -n openshift-config delete secrets htpasswd-secret 
oc -n openshift-config create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd-ex267.text
```

- Create one **group** called `devops-wala` and this group must have `developer`, `rajan` and `punit` **users**.
- These users must able to access RHOAI dashboard but neither the part of **admin group** and nor **other groups**.
- Make sure only `rhods-admins` group is the part of Administrator group.
