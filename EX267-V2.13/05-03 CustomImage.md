# 🚀  Create a Custom Notebook Image

## 🎯 Lab Preparation –  Check more details from Chapter 5

```
lab start -t AI263 customnotebook-create
cat <<EOF >> /home/student/AI263/labs/customnotebook-create/requirements.txt
seaborn==0.12.2
python-json-logger==2.0.7
EOF
```
👨‍💻 What will you learn from this task?
---
- How to create a custom image from a Containerfile and push it to a registry
- How to import the custom workbench image into RHOAI
- Add the data visualization library seaborn, based on matplotlib, to a workbench image.
- Create a workbench from a custom workbench image.
--- 

## 🔹 You need to perform the following tasks.
1. A container image built from the source is `registry.ocp4.example.com:8443/student/custom-workbench-image:1.0`
	- Containerfile is located under `/home/student/AI263/labs/customnotebook-create` directory.
	- Build a new **custom image** named **`custom-workbench-image`** with **`1.0`** tag. 
2. Import a custom workbench image into RHOAI.
	- **Import a custom workbench image** named `custom-workbench` for use in Red Hat OpenShift AI (RHOAI).
	- Description of notebook image should be **`The image provides the seaborn Python package.`**
	- For image displayed contents, the **software name** `Python` is set to version `v2.2.0`
	- For image displayed contents, the **package name** shown which are mentioned in the `requirements.txt` file.
	- Use the `requirements.txt` file to add **`seaborn v0.12.2`** and **`python-json-logger v2.0.7`** softwares in the image.
3. Create a workbench `custom-wb` from the custom image `custom-workbench` in the project `customnotebook-create`.
	- Verify that the workbench has the seaborn Python package pre-installed.

---

## 👨‍💻 Solution

### 1. A container image built from the source is .......
```
cd /home/student/AI263/labs/customnotebook-create
```

### ➡️ You need to login into the Registry.
```
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

<img width="1819" height="683" alt="image" src="https://github.com/user-attachments/assets/d933718d-22e3-4198-a955-f0ab499ebd5b" />

<img width="1819" height="683" alt="Screenshot 2026-04-11 at 8 28 15 PM" src="https://github.com/user-attachments/assets/d1ee5be4-edfc-4ef5-b1c2-9e73014c32a3" />


### ➡️  Build the container. 
```
podman build . -t registry.ocp4.example.com:8443/student/custom-workbench-image:1.0
```
➡️ For your references
```
[student@workstation customnotebook-create]$ podman images
REPOSITORY                                                      TAG                                                         IMAGE ID      CREATED         SIZE
registry.ocp4.example.com:8443/student/custom-workbench-image   1.0                                                         1ca8adc5ae91  12 minutes ago  4.45 GB
registry.ocp4.example.com:8443/redhattraining/ai265-models      2.13                                                        5c5b3751e77c  16 months ago   268 MB
registry.ocp4.example.com:8443/opendatahub/workbench-images     jupyter-datascience-ubi9-python-3.9-2023b-20240219-ffe72a0  769eda83a903  2 years ago     2.9 GB
```
### ➡️ Push the image to the registry.
```
podman push registry.ocp4.example.com:8443/student/custom-workbench-image:1.0
```

### 2. Import a custom workbench image into RHOAI.

- Open a browser and go to `https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com` to access the RHOAI dashboard.

- Log in as the `admin` user by using the `redhatocp` password.
- At left, click **`Settings → Notebook images`**, after that **`click Import new image`**.
- Enter `registry.ocp4.example.com:8443/student/custom-workbench-image:1.0` as the `**Image location`** and enter `**custom-workbench`** as the name.

|Meaning: |Value |
|--|--|
| Image location | registry.ocp4.example.com:8443/student/custom-workbench-image:1.0 |
| Notebook image name | custom-workbench |

- As per the task, you need to add the **description** `**The image provides the seaborn Python package.`**

- Scroll to the **Software** section and click **Add software**.

Add the following software information:

| Software | Version |
|---|---|
| Python | v2.2.0 |

- Next, scroll to the **Packages** section and click **Add package**.

Add the following packages. These package information must be in the `requirements.txt` file.

| Package | Version |
|---|---|
| seaborn | 0.12.2 |
| python-json-logger | 2.0.7 |

### 3. Create a workbench `custom-wb` from the custom image...


- **Login in** as `admin` user by using the `redhatocp` password on RHOAI dashboard.
- From the left side navigation, click `Data Science Projects`, and then click the `customnotebook-create` project.

- On the Workbenches tab, click **Create workbench**.

- Provide **`custom-wb`** as the name, and select the `custom-workbench` **image** from the Image selection field. Leave the default values in other fields, and click **Create workbench**.

- Wait for the **status** column to show `Running`. When it is ready, click `Open` to open the workbench in a new browser tab.


## ➡️ Run the notebook cells and then import the joblib in the first cell.
```
import joblib
```
## ➡️ Add the below content in the cell where it is written `"saving THE JOBLIB Model file"`
```
joblib.dump(model, "/opt/app-root/src/AI26X-apps/carido-model.joblib")
```

## 🧠  This saves the trained model:
- by using joblib
- into the root of the cloned repository
- with the name `carido-model.joblib`


