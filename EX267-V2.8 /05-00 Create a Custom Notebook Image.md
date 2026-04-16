## Question: Create custom notebook images and then import custom notebook images to Red Hat OpenShift AI

- Build a custom workbench image named `custom-workbench:1.0` for use in Red Hat OpenShift AI (RHOAI).
  - Use the `Containerfile` in the `/home/student/AI263/labs/customnotebook-create/` directory.
- Add the data visualization library `seaborn` package with version `0.12.2` to a workbench image.
- Import a custom workbench image into RHOAI.
- Create a workbench `custom-wb` from a custom workbench image under the project `customnotebook-create`.

---

## 1. Log in to the registry

The registry URL and credentials are provided in the **`ReadMe.md`** file.

```bash
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

## 2. Create an image from the given Containerfile
### 2.1 Go to the specified directory
```
cd /home/student/AI263/labs/customnotebook-create/
```

## 2.2 Build the image
```
podman build . -t registry.ocp4.example.com:8443/student/custom-workbench:1.0
```

### 2.3 Add the seaborn package (version 0.12.2) to the workbench image
If not already handled in the Containerfile, ensure the package is listed in a requirements.txt file:

```
echo "seaborn==0.12.2" > requirements.txt
```

**Note: For seaborn to actually be installed in the image, the Containerfile must include a command such as:**

```
RUN pip install -r requirements.txt

```
### 2.4 Push the newly created image to the registry
```
podman push registry.ocp4.example.com:8443/student/custom-workbench:1.0
```
- If the command fails due to a missing bearer token, run the podman push command again.

## 3. Import the custom workbench image into RHOAI
1. Open RHOAI in a browser `https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com`
2. Log in as the `admin` user with the `redhatocp` password.
3. In the left navigation, click Settings ➔ **Notebook images**, then click **Import new image**.
4. In the form:
  - Set Image location to: `registry.ocp4.example.com:8443/student/custom-workbench:1.0`
  - Set Name to: `custom-workbench`

5. Scroll to the bottom of the form, select the `Packages tab`, and click `Add packages`.
6. Add the `seaborn` package and set the version to `0.12.2`. Click the `check` button on the right side of the row to confirm.

**Note:** Specifying packages on this screen only documents what is available to users. It does not install anything into the image. The image must already contain seaborn.

## 4. Create a workbench from the custom workbench image
Once the image is imported into the RHOAI portal, create a workbench as the `developer` user.

  1. Log out the admin user from the RHOAI dashboard and log back in as the developer user (password: developer).
  2. In RHOAI, click Data Science Projects, then click the customnotebook-create project.
  3. On the Workbenches tab, click Create workbench.
  4. In the form:
    - Set Name to: `custom-wb`
    - Select the Image as: `custom-workbench`
  
  5. Click Create `workbench`.
  6. Wait until the Status column shows `Running`, then click `Open`.
  7. Authenticate as the `developer` user with the `developer` password. Accept the `default` permissions by clicking `Allow selected permissions`.

## 5. Verify that the seaborn Python package is pre-installed
- In the Jupyter Launcher interface, create a notebook by clicking `Python 3.9` under the **Notebook section**.

- In an empty notebook cell, run:

```
pip list | grep seaborn
```
- Execute the notebook cell by pressing `Shift+Enter` or by clicking `Run → Run Selected Cells`.

- If you see the `seaborn` package listed with version `0.12.2`, it confirms that the image has **seaborn pre-installed**.

## 6. Clean up the lab
```
lab finish customnotebook-create
```

