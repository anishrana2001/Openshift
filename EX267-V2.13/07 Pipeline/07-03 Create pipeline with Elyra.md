

## 🎯 How to prepare the lab? 
```bash
lab start -t AI266 pipelines-elyra
```

# 🧩  Create configure, run, and verify an Elyra pipeline
- Pipeline named **`issues_prediction.pipeline`** in the **`pipelines-elyra`** data science project by using the **`pipelines-elyra-wb`** workbench.
    - PV size of workbench must be 10 GB.
    - Clone a repository from URL `https://github.com/RedHatTraining/AI26X-apps` and use the branch **`RHOAI2.13`**.
    - Navigate to `AI26X-apps/pipelines/pipelines-elyra` directory.
    - The runtime image must be **`forecast-pipeline-runtime`** from url `quay.io/redhattraining/forecast-pipeline-runtime:1.0`.
- Use the existing **`s3-minio`** data connection.
    | Environment Variable | Secret Name | Secret Key |
    |---|---|---|
    | `AWS_ACCESS_KEY_ID` | `aws-connection-s3-minio` | `AWS_ACCESS_KEY_ID` |
    | `AWS_SECRET_ACCESS_KEY` | `aws-connection-s3-minio` | `AWS_SECRET_ACCESS_KEY` |
    | `AWS_S3_ENDPOINT` | `aws-connection-s3-minio` | `AWS_S3_ENDPOINT` |
    | `AWS_S3_BUCKET` | `aws-connection-s3-minio` | `AWS_S3_BUCKET` |

- The required Python pipeline nodes to generate **`data.csv, clean-data.csv, and forecast-data.csv`**?





## 👨‍💻Scenario

A data science project named **`pipelines-elyra`** already exists in Red Hat OpenShift AI.

You are required to create, configure, run, and verify an Elyra-based data science pipeline in JupyterLab. The pipeline must ingest support case data from an S3 bucket, preprocess the data, train a forecasting model, and generate prediction output files.

The pipeline should predict the number of customer support tickets expected in the next four weeks.

Do not create any unnecessary additional projects or pipelines. Use the specified project, workbench, runtime image, data connection, pipeline name, and output file names.

---

✅ **Complete Step-by-Step Solution**

➡️ Perform the following tasks:


1. 🔹Log in to the Red Hat OpenShift AI dashboard.

   Dashboard URL:

   ```text
   https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com
   ```

2. Click **Log in with OpenShift**.

3. Select **htpasswd_provider**.

4. Log in by using the following credentials:

   ```text
   Username: developer
   Password: developer
   ```

6. In the left navigation pane, click **Data Science Projects**.

7. Open the data science project named:

   ```text
   pipelines-elyra
   ```

---

## ➡️ Workbench Configuration

8. Create a workbench under the **`pipelines-elyra`** data science project.

9. Use the following workbench name:

   ```text
   pipelines-elyra-wb
   ```

10. Configure the workbench to use the following notebook image:

    ```text
    Standard Data Science
    ```

11. In the **Cluster storage** section, keep **Create new persistent storage** selected.

12. Set the persistent storage capacity to:

    ```text
    10 Gi
    ```

13. At the bottom of the workbench creation form, select:

    ```text
    Use a data connection
    ```

14. Select:

    ```text
    Use existing data connection
    ```

15. Attach the existing data connection named:

    ```text
    s3-minio
    ```

16. Create the workbench.

---

## ➡️ Open the Workbench and Clone the Repository

17. In the **Workbenches** section, open the workbench named:

    ```text
    pipelines-elyra-wb
    ```

18. Authenticate as the **developer** user.

19. Use the following password:

    ```text
    developer
    ```

20. Accept the requested permissions by clicking **Allow selected permissions**.

21. In JupyterLab, click the **Git** icon from the left tools pane.

22. Click **Clone a repository**.

23. Clone the following Git repository:

    ```text
    https://github.com/RedHatTraining/AI26X-apps
    ```

24. In the JupyterLab file browser, open the following directory:

    ```text
    AI26X-apps
    ```

25. Click the **Git** icon.

26. Change the current branch to:

    ```text
    RHOAI2.13
    ```

27. In the JupyterLab file browser, navigate to the following exercise directory:

    ```text
    AI26X-apps/pipelines/pipelines-elyra
    ```

---

## ➡️ Runtime Image Configuration

28. In the left pane, click **Runtime Images**.

29. Add a new runtime image by clicking the **+** icon.

30. Use the following display name:

    ```text
    forecast-pipeline-runtime
    ```

31. Use the following image name:

    ```text
    quay.io/redhattraining/forecast-pipeline-runtime:1.0
    ```

32. Click **Save & Close**.

33. Verify that the runtime image named **`forecast-pipeline-runtime`** appears in the Runtime Images section.

---

## ➡️ Pipeline Creation and Configuration

34. From the JupyterLab launcher tab, in the **Elyra** section, click:

    ```text
    Pipeline Editor
    ```

35. Rename the pipeline tab to:

    ```text
    issues_prediction.pipeline
    ```

36. Open the pipeline configuration panel by clicking **Open Panel** next to:

    ```text
    Runtime: Data Science Pipelines
    ```

37. Scroll down to the **Generic Node Defaults** section.

38. Select the following runtime image as the common runtime image for all nodes:

    ```text
    forecast-pipeline-runtime
    ```

39. Configure S3 access for the pipeline by adding Kubernetes secrets.

40. In the **Kubernetes Secrets** section, click **Add** and configure the following entries:

    | Environment Variable | Secret Name | Secret Key |
    |---|---|---|
    | `AWS_ACCESS_KEY_ID` | `aws-connection-s3-minio` | `AWS_ACCESS_KEY_ID` |
    | `AWS_SECRET_ACCESS_KEY` | `aws-connection-s3-minio` | `AWS_SECRET_ACCESS_KEY` |
    | `AWS_S3_ENDPOINT` | `aws-connection-s3-minio` | `AWS_S3_ENDPOINT` |
    | `AWS_S3_BUCKET` | `aws-connection-s3-minio` | `AWS_S3_BUCKET` |

41. Save the pipeline.

---

## ➡️ Pipeline Nodes

42. Ensure that you are in the following directory in the JupyterLab file browser:

    ```text
    AI26X-apps/pipelines/pipelines-elyra
    ```

43. Add the following Python scripts as Elyra pipeline nodes by dragging them to the visual pipeline editor:

    ```text
    data_ingestion.py
    data_preprocessing.py
    data_training_and_forecasting.py
    ```

44. Connect the nodes in the following order:

    ```text
    data_ingestion.py -> data_preprocessing.py -> data_training_and_forecasting.py
    ```

45. Configure the output file for the **`data_ingestion.py`** node.

    Right-click the **`data_ingestion.py`** node, select **Open Properties**, go to the **Outputs** section, click **Add**, and enter:

    ```text
    data.csv
    ```

46. Configure the output file for the **`data_preprocessing.py`** node.

    Right-click the **`data_preprocessing.py`** node, select **Open Properties**, go to the **Outputs** section, click **Add**, and enter:

    ```text
    clean-data.csv
    ```

47. Configure the output file for the **`data_training_and_forecasting.py`** node.

    Right-click the **`data_training_and_forecasting.py`** node, select **Open Properties**, go to the **Outputs** section, click **Add**, and enter:

    ```text
    forecast-data.csv
    ```

48. Save the pipeline.

---

## ➡️ Run the Pipeline

49. Click the **Run Pipeline** button.

50. Ensure that the pipeline run name is:

    ```text
    issues_prediction
    ```

51. Click **OK**.

52. Elyra sends the pipeline definition to the pipeline server runtime.

53. The pipeline server creates a pipeline run.

54. Click **Run Details** to access the pipeline run in the **Experiments and runs** panel of the Red Hat OpenShift AI dashboard.

55. Wait until the pipeline run finishes successfully.

---

## ➡️ 🧠 Verify the Results in MinIO

56. Open the MinIO web console.

   MinIO URL:

   ```text
   https://minio-ui-minio.apps.ocp4.example.com
   ```

57. Log in to MinIO by using the following credentials:

   ```text
   Access Key: minio
   Secret Key: minio123
   ```

58. Open the S3 bucket named:

   ```text
   pipelines-elyra-bucket
   ```

59. Locate the output directory created by the pipeline run.

   The directory name should follow this format:

   ```text
   issues_prediction-timestamp
   ```

60. Inspect the generated pipeline output directory.

61. Verify that the directory contains the log files from each node execution.

62. Verify that the following output files are present:

   ```text
   data.csv
   clean-data.csv
   forecast-data.csv
   ```

---

## 🧠 Optional Forecast Visualization

63. Return to the **`pipelines-elyra-wb`** workbench.

64. Open the following notebook:

   ```text
   check_forecast.ipynb
   ```

65. In the second cell of the notebook, replace the placeholder value:

   ```text
   EDIT THIS
   ```

   with the generated S3 pipeline run folder name.

   Example:

   ```python
   pipeline_run_folder = "issues_prediction-timestamp"
   ```

66. Execute all notebook cells.

67. Verify that the notebook generates a graph showing the past and forecasted time-series data.

---

## Finish the Lab

68. On the workstation machine, complete the exercise by running the following command:

   ```bash
   lab finish pipelines-elyra
   ```

---

## Required Values Summary

| Item | Required Value |
|---|---|
| Lab Start Command | `lab start -t AI266 pipelines-elyra` |
| Data Science Project | `pipelines-elyra` |
| RHOAI Username | `developer` |
| RHOAI Password | `developer` |
| Workbench Name | `pipelines-elyra-wb` |
| Notebook Image | `Standard Data Science` |
| Persistent Storage | `10 Gi` |
| Data Connection | `s3-minio` |
| Git Repository | `https://github.com/RedHatTraining/AI26X-apps` |
| Git Branch | `RHOAI2.13` |
| Exercise Directory | `AI26X-apps/pipelines/pipelines-elyra` |
| Runtime Image Display Name | `forecast-pipeline-runtime` |
| Runtime Image | `quay.io/redhattraining/forecast-pipeline-runtime:1.0` |
| Pipeline Name | `issues_prediction.pipeline` |
| Pipeline Run Name | `issues_prediction` |
| S3 Bucket | `pipelines-elyra-bucket` |
| MinIO Access Key | `minio` |
| MinIO Secret Key | `minio123` |
| Lab Finish Command | `lab finish pipelines-elyra` |

---

## Pipeline Node Summary

| Order | Pipeline Node | Output File |
|---|---|---|
| 1 | `data_ingestion.py` | `data.csv` |
| 2 | `data_preprocessing.py` | `clean-data.csv` |
| 3 | `data_training_and_forecasting.py` | `forecast-data.csv` |

---

## S3 Secret Configuration Summary

| Environment Variable | Secret Name | Secret Key |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | `aws-connection-s3-minio` | `AWS_ACCESS_KEY_ID` |
| `AWS_SECRET_ACCESS_KEY` | `aws-connection-s3-minio` | `AWS_SECRET_ACCESS_KEY` |
| `AWS_S3_ENDPOINT` | `aws-connection-s3-minio` | `AWS_S3_ENDPOINT` |
| `AWS_S3_BUCKET` | `aws-connection-s3-minio` | `AWS_S3_BUCKET` |

---

## Expected Result

After completing the task, the Elyra pipeline named **`issues_prediction.pipeline`** should run successfully in the **`pipelines-elyra`** data science project.

The pipeline should use the **`pipelines-elyra-wb`** workbench, the **`forecast-pipeline-runtime`** runtime image, and the **`s3-minio`** data connection.

The following files must be generated in the **`pipelines-elyra-bucket`** S3 bucket:

```text
data.csv
clean-data.csv
forecast-data.csv
```

