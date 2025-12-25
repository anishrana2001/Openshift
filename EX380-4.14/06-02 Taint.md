### prepare the lab.
```
oc adm taint node $(oc get nodes | awk '{print $1}' | grep -v NAME) datacenter=delhi:NoSchedule
oc new-project chapter1
oc new-app --name webserver-app1 --image registry.ocp4.example.com:8443/redhattraining/hello-world-nginx:v1.0
```

# Question: An application is running on the `chapter1` project. There is one pod running and your task is it must generate the output.
