# Creating Pipelines with the Kubeflow SDK

## Objective

Create, compile, import, and schedule a Kubeflow pipeline in Red Hat OpenShift AI.

The pipeline must be imported with the name **`tas1-devops-wala`** under the project **`pipelines-kfp`** and configured to run as a scheduled job every **5 minutes**.

---

## Prepare the Lab for This Task

Run the following commands from the terminal:

```bash
cat <<'EOF' > /tmp/simple_pipeline.py
from kfp import dsl
from kfp import compiler


@dsl.component(base_image="python:3.11")
def generate_message(name: str) -> str:
    return f"Hello {name}, welcome to Red Hat OpenShift AI pipelines and thanks for watching my videos"


@dsl.component(base_image="python:3.11")
def print_message(message: str):
    print(message)


@dsl.pipeline(
    name="simple-rhoai-kubeflow-pipeline",
    description="A simple pipeline created using the Kubeflow SDK"
)
def simple_pipeline(name: str = "Student"):
    message_task = generate_message(name=name)
    print_message(message=message_task.output)


if __name__ == "__main__":
    compiler.Compiler().compile(
        pipeline_func=simple_pipeline,
        package_path="simple_rhoai_pipeline.yaml"
    )
EOF

python -m pip install --user "kfp>=2.14.3"

lab start -t AI266 pipelines-kfp
```

> **Note:** The script `/tmp/simple_pipeline.py` compiles the pipeline into a YAML file named **`simple_rhoai_pipeline.yaml`**. This YAML file is the file that should be imported into Red Hat OpenShift AI, not the Python script.

---

# Task: Creating Pipelines with the Kubeflow SDK

Your task is to run the pipeline named **`tas1-devops-wala`** under the project **`pipelines-kfp`**.

The pipeline must run every **5 minutes** as a **scheduled job**.

The Python script is available at:

```bash
/tmp/simple_pipeline.py
```

---

# Solution

## Step 1: Open the CLI Console of the Bastion VM

Open the terminal on the bastion/workstation VM.

---

## Step 2: Go to the `/tmp` Directory

```bash
cd /tmp
ls -ltr
```

Verify that the file exists:

```bash
ls -l /tmp/simple_pipeline.py
```

---

## Step 3: Create and Activate a Python Virtual Environment

```bash
python3.9 -m venv .venv
source .venv/bin/activate
```

Verify that the virtual environment is active:

```bash
which python
python --version
```

---

## Step 4: Install the Kubeflow Pipelines SDK

Install the KFP SDK:

```bash
pip install "kfp>=2.14.3"
```

Verify the installation:

```bash
python -c "import kfp; print(kfp.__version__)"
```

---

## Step 5: Inspect the Pipeline Script

View the script to understand the pipeline definition:

```bash
cat /tmp/simple_pipeline.py
```

The script contains:

- `@dsl.component` definitions for pipeline components.
- `@dsl.pipeline` definition for the pipeline workflow.
- A compiler command that generates the pipeline YAML file.

---

## Step 6: Compile the Pipeline into YAML

Run the Python script:

```bash
python /tmp/simple_pipeline.py
```

This command generates the following YAML file:

```bash
/tmp/simple_rhoai_pipeline.yaml
```

Verify that the YAML file was created:

```bash
ls -l /tmp/simple_rhoai_pipeline.yaml
```

---

## Step 7: Import the Pipeline in Red Hat OpenShift AI

1. Open a web browser.
2. Navigate to:

   ```text
   https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com
   ```

3. Log in with the following credentials:

   ```text
   Username: developer
   Password: developer
   ```

4. From the left navigation pane, click **Data Science Pipelines**.
5. Make sure the selected project is **`pipelines-kfp`**.
6. Click **Import pipeline**.
7. In the **Pipeline name** field, enter:

   ```text
   tas1-devops-wala
   ```

8. Click **Upload**.
9. Select the compiled YAML file:

   ```text
   /tmp/simple_rhoai_pipeline.yaml
   ```

10. Click **Import pipeline**.

---

## Step 8: Create a Scheduled Run

1. Open the imported pipeline named **`tas1-devops-wala`**.
2. Click **Actions** → **Create schedule**.
3. Under **Project and experiment**, in the **Experiment** field, select:

   ```text
   Default
   ```

4. Under **Schedule details**, in the **Name** field, enter:

   ```text
   tas1-devops-wala-s1
   ```

5. In the **Trigger type** field, select:

   ```text
   Periodic
   ```

6. In the **Run every** field, select:

   ```text
   Every 5 minutes
   ```

7. Under the **Pipeline** section, select:

   ```text
   tas1-devops-wala
   ```

8. Click **Create schedule**.

---

## Step 9: Verify the Pipeline Schedule

After creating the schedule:

1. Go to **Data Science Pipelines**.
2. Open the project **`pipelines-kfp`**.
3. Check the pipeline **`tas1-devops-wala`**.
4. Confirm that the schedule **`tas1-devops-wala-s1`** is listed.
5. Wait for the scheduled run to start.
6. Confirm that the run completes successfully.

---

## Troubleshooting

### Issue 1: `ModuleNotFoundError: No module named 'kfp'`

If you see the following error:

```text
ModuleNotFoundError: No module named 'kfp'
```

Install the Kubeflow Pipelines SDK:

```bash
pip install "kfp>=2.14.3"
```

Then run the script again:

```bash
python /tmp/simple_pipeline.py
```

---

### Issue 2: Virtual Environment Activation Fails

If this command fails:

```bash
source .venv/bin/activate
```

Check that the virtual environment was created correctly:

```bash
ls -l .venv/bin/activate
```

If the file does not exist, recreate the virtual environment:

```bash
rm -rf .venv
python3.9 -m venv .venv
source .venv/bin/activate
```

---

### Issue 3: YAML File Not Found During Import

If the YAML file is missing, compile the pipeline again:

```bash
cd /tmp
python simple_pipeline.py
ls -l simple_rhoai_pipeline.yaml
```

Use this file during import:

```text
/tmp/simple_rhoai_pipeline.yaml
```

Do not upload the Python file. Upload the compiled YAML file.

---

## Final Validation

The task is complete when:

- The Python script exists at **`/tmp/simple_pipeline.py`**.
- The compiled YAML file exists at **`/tmp/simple_rhoai_pipeline.yaml`**.
- The pipeline is imported as **`tas1-devops-wala`**.
- The pipeline is under the project **`pipelines-kfp`**.
- The schedule is named **`tas1-devops-wala-s1`**.
- The schedule runs every **5 minutes**.
- At least one scheduled pipeline run completes successfully.