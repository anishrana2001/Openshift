## Question: Create custom notebook images and then import custom notebook images to Red Hat OpenShift AI.
- Build a custom workbench image named `custom-workbench:1.0` for use in Red Hat OpenShift AI (RHOAI)
    - Use file `Containerfile` in the `/home/student/AI263/labs/customnotebook-create/` directory.
- Add the data visualization library `seaborn` package and version `0.12.2`. to a workbench image.
- Import a custom workbench image into RHOAI.
- Create a workbench `custom-wb` from a custom workbench image under project `customnotebook-create`.
--- 
---

## Login into the registary, url name must be in the **`ReadMe.md`** file.
```
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

## Create a image from given **`Containerfile`** file.
### - Go to the mentioned directory.
```
cd /home/student/AI263/labs/customnotebook-create/
```
#### - Create (build) an image.
```
podman build . -t registry.ocp4.example.com:8443/student/custom-workbench:1.0
```
### As per the 2nd task "Add the data visualization library `seaborn` package and version `0.12.2`. to a workbench image."
```
echo "seaborn==0.12.2" > requirements.txt
```

#### Push the newly created image to the registry.
```
podman push registry.ocp4.example.com:8443/student/custom-workbench:1.0
```

- **If the command fails due to a missing bearer token, then try the command again.**

### Task 3rd "Import a custom workbench image into RHOAI."

- Open RHOAI in a browser `https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com`. Log in as the `admin` user by using the `redhatocp` password.

- Left navigation, **click** Settings ➔ **Notebook images**, and then **click** `Import new image`.

#### Within the form, specify `registry.ocp4.example.com:8443/student/custom-workbench:1.0` as the **Image location** and enter `custom-workbench` as the name. 

- Scroll to the bottom of the form, select the `Packages` tab, and click `Add packages`.

- Mention `seaborn`** **package** and **version** `0.12.2`. Click the `check button` in the right side of the row to confirm.
- Please note that **specifying any additional packages name only provides information to users. This does'nt add anything to the image.** 

### Once, we Imported the images in the RHOAI portal, we can now create a workbench from `developer` user.

- Log out from `admin` user from RHOAI dashboard & log back in as `developer` user, password `developer` password.

- RHOAI: Click on `Data Science Projects`, and then click the `customnotebook-create` project.

- On the **Workbenches** tab, click `Create` workbench.

- Provide `custom-wb` as the name, and select the `custom-workbench` image from the Image selection field. Hit the button `Create workbench`.

- After sometime, status column to show **Running**. After that click `Open`

- Authenticate as the `developer` user with the `developer` password. Accept the default permissions by clicking `Allow selected permissions`.

- How to verify the `seaborn` Python package pre-installed?

    - Within the `Jupyter Launcher interface,` create a notebook by clicking `Python 3.9` under the Notebook section.
    - Within the empty notebook cell, execute the command.
    ```
    pip list | grep seaborn
    ```
    - Execute the notebook cell by either pressing `Shift+Enter` or by clicking `Run → Run Selected Cells`.

- If you observe the seaborn package then it means that this image has the `seaborn` package pre-installed.

### How to clear the lab?
```
lab finish customnotebook-create
```