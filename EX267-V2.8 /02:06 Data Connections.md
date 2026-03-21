## Prepare the lab.
```
lab start -t AI262 projects-data
```
Question: Create a data connection in Red Hat OpenShift AI (RHOAI) that stores information to connect to an S3 bucket.

- Use the following values to fill out and submit the form.

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| Name        | projects-data-connection                           |
| Access key  |  minio                                             |
| Secret key  | minio123                                           |
| Endpoint    | https://minio-api-minio.apps.ocp4.example.com      |
| Region      | us-east-1                                          |
| Bucket      | projects-data-bucket                               |


- Attach a data connection to a workbench `projects-data-wb` in RHOAI under `projects-data` project and use `Standard Data Science` as a image.
- Use the data connection values to upload and download objects to the S3 bucket within a Python Jupyter notebook.

---

### Solution:

# Lab: Create an S3 Bucket in MinIO and Use It in a Workbench

In this lab, you will:

- Create an S3 bucket in MinIO.
- Create a data connection in Red Hat OpenShift AI (RHOAI).
- Create a workbench that uses this data connection.

---

## 1. Create an S3 bucket in MinIO

1. Open a web browser and go to the MinIO UI:  
   `https://minio-ui-minio.apps.ocp4.example.com`

2. Log in with:
   - **Username:** `minio`
   - **Password:** `minio123`

3. Because there is no bucket yet, the UI will prompt you to create one.
   - Click **Create a Bucket**.
   - Enter the bucket name: `projects-data-bucket`.
   - Click **Create Bucket**.
   - Leave all other options at their default values.

---

## 2. Create a data connection in the `projects-data` Data Science Project

1. Open a new browser tab and go to the RHOAI dashboard:  
   `https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com`

2. Log in as:
   - **Username:** `developer`
   - **Password:** `developer`

3. From the left navigation pane, click **Data Science Projects**.

4. Click the project named **projects-data**.

5. Go to the **Data connections** tab.

6. Click **Add data connection**  
   (You might need to scroll down to see this button.)

7. Fill in the form with the following values:

   | Field      | Value                                                         |
   |-----------|---------------------------------------------------------------|
   | Name      | projects-data-connection                                      |
   | Access key| minio                                                         |
   | Secret key| minio123                                                      |
   | Endpoint  | https://minio-api-minio.apps.ocp4.example.com                 |
   | Region    | us-east-1                                                     |
   | Bucket    | projects-data-bucket                                          |

8. Submit the form to create the data connection.

---

## 3. Create a new workbench that uses this data connection

1. In the same **projects-data** project, go to the **Workbenches** tab.

2. Click **Create workbench**.

3. In the form:
   - Set **Name** to: `projects-data-wb`.
   - Select **Standard Data Science** as the image.
   - Do **not** submit yet.

4. Scroll to the bottom of the form.

5. Enable the **Use a data connection** checkbox.

6. Select **Use existing data connection**.

7. From the dropdown, choose **projects-data-connection**. This is what we created i the Step 2, rigth ?

8. Leave all other fields at their default values.

9. Click **Create workbench**.

10. Wait until the **Status** column for `projects-data-wb` shows **Running**.  
    This means the workbench is ready.

11. When the workbench is running, click **Open** in the same row.

12. When prompted to authenticate, log in with:
    - **Username:** `developer`
    - **Password:** `developer`

13. Accept the requested permissions by clicking **Allow selected permissions**.

You have now:

- Created an S3 bucket in MinIO.
- Created a data connection in RHOAI.
- Created a workbench that uses this S3 data connection.

