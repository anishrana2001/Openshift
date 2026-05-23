# Modify Workbench and Clone Git Repository

## Lab Preparation – Chapter 2

Before starting the lab, initialize the environment by running the following command:

```bash
lab start -t AI262 notebooks-collaboration
```

---

# Lab Objective

In this exercise, you will modify an existing workbench, configure an environment variable using a ConfigMap, and clone a Git repository inside JupyterLab.

By the end of this lab, you will be able to:

- Modify an existing workbench configuration
- Change the notebook image
- Configure environment variables using ConfigMap
- Clone a Git repository in JupyterLab
- Switch Git branches
- Open and verify notebook files

> **Important:**  
> Do **not** delete the existing workbench and create a new one. You must modify the already available workbench.

---

# Lab Requirements

A workbench named `git-experiments` already exists in the `notebooks-collaboration` data science project.

You are required to perform the following tasks:

| Configuration | Required Value |
|---|---|
| Workbench Name | `git-experiments` |
| Project Name | `notebooks-collaboration` |
| Notebook Image | `CUDA` |
| ConfigMap Key | `RANDOM_SIZE` |
| ConfigMap Value | `40` |
| Git Repository | `https://github.com/RedHatTraining/AI26X-apps` |

---

# Step 1: Open the Existing Workbench

1. Navigate to **Data Science Projects**.
2. Open the project:

   ```text
   notebooks-collaboration
   ```

3. Locate the existing workbench:

   ```text
   git-experiments
   ```

> **Instructor Note:**  
> The workbench may already be running with another notebook image such as **Minimal Python** or another image. Your task is to modify the existing workbench.

---

# Step 2: Modify the Notebook Image

1. Select the **git-experiments** workbench.
2. Click **Edit Workbench**.
3. Navigate to the **Notebook Image** section.
4. Change the notebook image to:

```text
CUDA
```

5. Save the changes.

> **Why this change?**  
> The lab requires the workbench to use the recommended **CUDA** notebook image.

---

# Step 3: Configure Environment Variable Using ConfigMap

Next, configure the required environment variable.

1. Open the workbench configuration.
2. Navigate to the **Environment Variables** section.
3. Select:

```text
ConfigMap
```

4. Add the following key-value pair:

| Key | Value |
|---|---|
| `RANDOM_SIZE` | `40` |

5. Save the configuration.

> **Tip:**  
> Double-check the spelling of both the key and value to avoid configuration issues.

---

# Step 4: Launch JupyterLab

After the workbench starts successfully:

1. Click **Open** to launch **JupyterLab**.
2. Wait for the notebook environment to load.

---

# Step 5: Clone the Git Repository

Inside JupyterLab:

1. Click the **Git** icon from the left sidebar.
2. Select **Clone a Repository**.
3. Enter the following repository URL:

```text
https://github.com/RedHatTraining/AI26X-apps
```

4. Click **Clone**.

Once cloning is complete, the repository will appear in the JupyterLab file browser.

---

# Step 6: Switch to the Required Branch

1. Open the **Git** panel.
2. Click **Current Branch**.
3. Change the branch to:

```text
origin/RHOAI2.13
```

> **Instructor Tip:**  
> Always verify the required branch during labs or certification exams. Using the wrong branch may result in missing notebooks or incorrect files.

---

# Step 7: Open the Notebook File

In the JupyterLab file browser, navigate to:

```text
AI26X-apps/intro/notebooks-collaboration
```

Open the following notebook:

```text
hello.ipynb
```

Double-click the notebook file to open it.

---

# Verification Checklist

Before completing the lab, verify the following tasks:

- [ ] Modified the existing workbench `git-experiments`
- [ ] Changed notebook image to `CUDA`
- [ ] Added ConfigMap variable `RANDOM_SIZE=40`
- [ ] Cloned the Git repository successfully
- [ ] Switched to branch `RHOAI2.13`
- [ ] Opened `hello.ipynb`
- [ ] Stopped the workbench after testing

---

# Common Mistakes to Avoid

❌ Deleting the existing workbench and creating a new one  
❌ Selecting the wrong notebook image  
❌ Forgetting to switch to the `RHOAI2.13` branch  
❌ Incorrectly configuring `RANDOM_SIZE=40`  
❌ Leaving the workbench running after validation

---

# Key Takeaways

After completing this exercise, you should be able to:

- Modify existing workbench settings
- Change notebook images in a data science environment
- Configure environment variables using ConfigMaps
- Clone Git repositories using JupyterLab
- Switch Git branches and open notebooks

---

## Cleanup Task

After testing your changes, ensure the workbench is stopped.

> **Best Practice:**  
> Stop unused workbenches to conserve cluster resources and maintain a clean lab environment.
