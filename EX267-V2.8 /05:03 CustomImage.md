# Create a Custom Notebook Image

## How to prepare the lab?  Chapter 5

```
lab start -t AI263 customnotebook-create
```

- Build a custom workbench image for use in Red Hat OpenShift AI (RHOAI).
- Add the data visualization library seaborn, based on matplotlib, to a workbench image.
- Import a custom workbench image into RHOAI.
- Create a workbench from a custom workbench image.
--- 


- A container image built from the source is `registry.ocp4.example.com:8443/opendatahub/workbench-images:jupyter-datascience-ubi9-python-3.9-2023b-20240219-ffe72a0`
- Build a new customer image named `custom-workbench` with `1.0` tag. 
- Import a custom workbench image into RHOAI.
- Build a custom workbench image `custom-workbench` for use in Red Hat OpenShift AI (RHOAI).
- Description of notebook image should be `The image provides the seaborn Python package.`
- For image displayed contents, the software name `seaborn` is set to version `0.12.2`
- For image displayed contents, `python-json-logger` software with version `2.0.7`
- Use the `requirements.txt` file to add **`seaborn v0.12.2`** and **`python-json-logger v2.0.7`** softwares in the image.
- Create a workbench `custom-wb` from the custom image `custom-workbench` in the project `customnotebook-create`.
- Verify that the workbench has the seaborn Python package pre-installed.
---

## 
```
cd /home/student/AI263/labs/customnotebook-create
```



cd ~/AI263/labs/customnotebook-create
cat ~/AI263/labs/customnotebook-create/requirements.txt

echo "seaborn==0.12.2" >> requirements.txt
echo "python-json-logger==2.0.7" >> requirements.txt

### You need to login into the Registry.
```
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

<img width="1819" height="683" alt="image" src="https://github.com/user-attachments/assets/d933718d-22e3-4198-a955-f0ab499ebd5b" />

<img width="1819" height="683" alt="Screenshot 2026-04-11 at 8 28 15 PM" src="https://github.com/user-attachments/assets/d1ee5be4-edfc-4ef5-b1c2-9e73014c32a3" />


### Build the container. 
```
podman build . -t registry.ocp4.example.com:8443/student/custom-workbench:1.0
```

```
student@workstation customnotebook-create]$ podman images
REPOSITORY                                                   TAG                                                         IMAGE ID      CREATED        SIZE
localhost/custom-workbench                                   1.0                                                         d8c3fb9af56c  2 minutes ago  4.45 GB
<none>                                                       <none>                                                      ddc02ee8bcec  5 minutes ago  2.9 GB
registry.ocp4.example.com:8443/opendatahub/workbench-images  jupyter-datascience-ubi9-python-3.9-2023b-20240219-ffe72a0  769eda83a903  2 years ago    2.9 GB
[student@workstation customnotebook-create]$ 
```
### Push the image to the registry.
```
podman push registry.ocp4.example.com:8443/student/custom-workbench:1.0
```

### Import the custom workbench image into RHOAI.

- Open a browser and go to `https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com` to access the RHOAI dashboard.
- Log in as the `admin` user by using the `redhatocp` password.
- At left, click **`Settings → Notebook images`**, after that **`click Import new image`**.
- Enter `registry.ocp4.example.com:8443/student/custom-workbench:1.0` as the `**Image location`** and enter `**custom-workbench`** as the name. 
- As per the task, you need to add the description `**The image provides the seaborn Python package.`**
- Scroll down of the form, select the `**Packages tab`**, and click `**Add packages`**.
- Specify the `**seaborn`** package and version `**0.12.2`**. Click the check button in the right side of the row to confirm.
