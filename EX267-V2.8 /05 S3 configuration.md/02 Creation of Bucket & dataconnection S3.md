# 🧪 EX267 Exam Practice – Data Connection with S3 (MinIO)

## 🎯 Question: Using data connections to access an S3 bucket from a workbench

- Create an S3 bucket named projects-data-bucket in the provided MinIO instance:

    - Open https://minio-ui-minio.apps.ocp4.example.com in a browser.
    - Log in with username: minio, password: minio123.
    - Create a bucket named projects-data-bucket with default settings.

- In the `projects-data` Data Science Project in `Red Hat OpenShift AI`:
	- Create a data connection with:

        | Field      | Value                                           |
        | ---------- | ----------------------------------------------- |
        | Name       | `projects-data-connection`                      |
        | Access Key | `minio`                                         |
        | Secret Key | `minio123`                                      |
        | Endpoint   | `https://minio-api-minio.apps.ocp4.example.com` |
        | Region     | `us-east-1`                                     |
        | Bucket     | `projects-data-bucket`                          |


- Create a new workbench `projects-data-wb`, use notebook image `Standard Data Science` and attach the data connection `projects-data-connection`


- You also need to clone the Git repository `https://github.com/RedHatTraining/AI26X-apps`
- Complete all the steps mentioned in the file `projects-data-nb.ipynb` under `AI26X-apps/intro/projects-data/`.

# ✅ Solution: Using Data Connections to Access an S3 Bucket from a Workbench

This solution walks through all the required steps to configure an S3-compatible bucket (MinIO), create a data connection in Red Hat OpenShift AI, and attach it to a workbench. [web:28][web:34][web:37][web:43]

---

## 1️⃣ Create the `projects-data-bucket` in MinIO

1. Open the **MinIO UI** in your web browser:

   ```text
   https://minio-ui-minio.apps.ocp4.example.com
   ```

2. Log in with the provided credentials:

   ```text
   Username: minio
   Password: minio123
   ```

3. Because no bucket exists yet, the UI prompts you to **Create a Bucket**.

4. Click **Create a Bucket** and fill in:

   ```text
   Bucket name: projects-data-bucket
   ```

5. Leave **all other values** as their default and click **Create Bucket**.

At this point, the `projects-data-bucket` S3-compatible bucket is created and ready to use. [web:39][web:37]

---

## 2️⃣ Create the `projects-data-connection` Data Connection

1. Open the **Red Hat OpenShift AI Dashboard**:

   ```text
   https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com
   ```

2. Log in as the **developer** user:

   ```text
   Username: developer
   Password: developer
   ```

3. From the left navigation pane, click **Data Science Projects** and then click the project:

   ```text
   projects-data
   ```

4. Go to the **Data connections** tab.

5. Scroll down if needed and click **Add data connection**.

6. Fill out the form using the following values:

   | Field      | Value                                                   |
   |-----------|---------------------------------------------------------|
   | Name      | `projects-data-connection`                              |
   | Access key| `minio`                                                 |
   | Secret key| `minio123`                                              |
   | Endpoint  | `https://minio-api-minio.apps.ocp4.example.com`         |
   | Region    | `us-east-1`                                             |
   | Bucket    | `projects-data-bucket`                                  |

7. Submit the form to create the data connection.

The `projects-data-connection` is now available to be attached to workbenches in this project. [web:28][web:34][web:30][web:43]

---

## 3️⃣ Create the `projects-data-wb` Workbench and Attach the Data Connection

1. In the same `projects-data` project, go to the **Workbenches** tab.

2. Click **Create workbench**.

3. Set the basic parameters:

   - **Name:** `projects-data-wb`  
   - **Image:** `Standard Data Science`  

4. Scroll to the bottom of the form and configure the data connection:

   - Enable the **Use a data connection** checkbox  
   - Select **Use existing data connection**  
   - Choose:

     ```text
     projects-data-connection
     ```

5. Leave all other fields as their **default values**.

6. Click **Create workbench**.

7. Wait until the **Status** of `projects-data-wb` shows:

   ```text
   Running
   ```

The workbench is now running with the `projects-data-connection` attached, and its connection details are injected as environment variables. [web:28][web:34][web:38]

---

## 4️⃣ Open the Workbench and Authenticate

1. In the **Workbenches** tab of the `projects-data` project, locate the row for:

   ```text
   projects-data-wb
   ```

2. Click **Open** in the same row.

3. When prompted, authenticate with:

   ```text
   Username: developer
   Password: developer
   ```

4. Accept any permission prompts by clicking:

   ```text
   Allow selected permissions
   ```

You are now inside the JupyterLab environment of the `projects-data-wb` workbench. [web:38]

---

## 5️⃣ Clone the Git Repository to Access the Notebook

1. In the **JupyterLab** interface, locate the **left-side tools pane**.

2. Click the **Git** icon (it resembles a branching graph).

3. In the Git panel or a terminal (if preferred), clone the training repository:

   ```bash
   git clone https://github.com/RedHatTraining/AI26X-apps
   ```

4. After cloning, you can navigate in the JupyterLab file browser to the relevant path to open the notebook (as defined in your lab instructions):

   ```text
   AI26X-apps/intro/projects-data/projects-data-nb.ipynb
   ```

From this point, you can use the notebook to interact with the `projects-data-bucket` using the `projects-data-connection` that was configured and attached to the workbench. [web:33][web:28][web:34]

---
