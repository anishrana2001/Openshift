# Red Hat OpenShift AI (EX267) - Data Science Pipelines Question

**Question / Task**

In the **manage-resources** Data Science Project, perform the following tasks:

1. Configure / Create a **Pipeline Server** (if not already present) using the existing `my-s3-connection` (or the MinIO details provided in previous tasks).

2. In the workbench `manage-resources-wb`, open the notebook `AI26X-apps/intro/projects-data/projects-data-nb.ipynb` (on branch `origin/RHOAI2.13`).

3. Create a **Data Science Pipeline** (using Elyra or export as KFP YAML) that includes the following steps from the notebook:
   - Data loading / preprocessing
   - Model training
   - Saving the model as `carido-model.joblib` (to S3 / root)

4. Import the pipeline into the OpenShift AI Dashboard under the **Pipelines** tab.

5. Create a **Pipeline Run** and verify that it completes successfully and the model is saved in the S3 bucket (`saved-models`).

**Use the same S3/MinIO credentials as before:**
- AWS_ACCESS_KEY_ID: `minio`
- AWS_SECRET_ACCESS_KEY: `minio123`
- Endpoint: `https://minio-api-minio.apps.ocp4.example.com`
- Bucket: `saved-models`
- Region: `any`

---

## ✅ Complete Step-by-Step Solution

### 1. Configure Pipeline Server (if not already done)

1. Go to **OpenShift AI Dashboard** → **Data Science Projects** → **manage-resources**.
2. Click the **Pipelines** tab.
3. Click **Configure pipeline server** (if not configured).
4. In **Object storage connection**:
   - Select existing connection **`my-s3-connection`** (or fill manually with MinIO details above).
   - Bucket: `saved-models`
5. For Database: Use **default database** (for exam purposes).
6. Click **Configure pipeline server** and wait until it is Ready.

### 2. Create Pipeline in Workbench (Elyra - Most Common Method)

1. Open the workbench **manage-resources-wb**.
2. Open the notebook `AI26X-apps/intro/projects-data/projects-data-nb.ipynb`.
3. In JupyterLab: **File → New → Data Science Pipeline Editor**.
4. Drag the relevant notebooks or Python scripts as pipeline steps.
5. For each node (especially the training step):
   - Right-click → **Open Properties**.
   - Set **Runtime** to the pipeline runtime (using `my-s3-connection`).
   - Add **File Dependencies** if needed.
   - For the model save step: Ensure it saves `carido-model.joblib`.
6. Connect the steps in sequence.
7. Click the **Export Pipeline** button → Export as **KFP YAML** (e.g., `carido-training-pipeline.yaml`).

### 3. Import Pipeline in Dashboard

1. Back in OpenShift AI Dashboard → **Pipelines** tab (in manage-resources project).
2. Click **Import pipeline**.
3. Upload the `carido-training-pipeline.yaml` file.
4. Give it a name (e.g., `carido-model-training-pipeline`) and import.

### 4. Create and Run the Pipeline

1. Select the imported pipeline.
2. Click **Create run**.
3. Configure any parameters if required.
4. Click **Start** / **Create run**.
5. Monitor the run until it shows **Succeeded**.

### 5. Verification

- Check the pipeline run logs for each step.
- Verify in MinIO / S3 (`saved-models` bucket) that `carido-model.joblib` exists.
- (Optional) In a notebook, use boto3 to list objects in the bucket.

---

**Final Checklist**
- [ ] Pipeline Server configured with S3
- [ ] Pipeline created via Elyra / KFP YAML
- [ ] Pipeline successfully imported and run
- [ ] Model `carido-model.joblib` saved to S3 bucket
- [ ] No errors in pipeline execution

**Good Luck!** Pipeline tasks are heavily weighted in EX267.