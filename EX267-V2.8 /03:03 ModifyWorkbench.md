## How to prepare the lab?  Chapter 2

```
lab start -t AI262 notebooks-collaboration
```

## In this question, your tasks are to modify the notebook image, Add a new Environment variable through ConfigMap and then 
## clone the Git Repo in the Jupiter notebook.

### A workbench named `git-experiments` already exist in the `notebooks-collaboration` data science project:
- Do not delete the workbench and create a new workbench. You have to modify it.
- Modify the **workbench** to use the recommended **notebook image** `Standard Data Science` `HabanaAI`.
- Modify the **workbench** to use **ConfigMap** with key `RANDOM_SIZE` set to value `40`
- It the Jupyter notebook, clone the repository **`https://github.com/RedHatTraining/AI26X-apps`**
- After testing your changes, ensure the workbench is stopped.
---

### Solution:

You can see `notebooks-collaboration` **project** under **data science projects** tab.
  - In that project, you can see `git-experiments` **workbench** running with **Notebook image** `Minimal Python` or
     `some other image` except `Standard  Data Science` image.
- Conditions – we have to **edit workbench** and modify image to **Standard Data Science** image and provide **environment variable** -> **Configmap** -> **key/value** -> in key provide `RANDOM_SIZE` and in value provide `40`.

- In the JupyterLab interface, click the **Git** icon from the left tools pane.
Click **Clone** a Repository.

- Enter `https://github.com/RedHatTraining/AI26X-apps` as the repository, and click **Clone**.

- In the JupyterLab file browser, enter the AI26X-apps directory.

**Click** the **Git icon**, and change to the **RHOAI2.13** branch by clicking **Current Branch** and selecting **origin/RHOAI2.13**.
- In the JupyterLab file browser, navigate to the `AI26X-apps/intro/notebooks-collaboration` directory and double click the `hello.ipynb` notebook to open it.

