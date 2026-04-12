# Q2 Change the workbench size.

## How to prepare the lab?
#### LAB NAME: Guided Exercise: Managing Resources

```
lab start -t AI263 manage-resources
lab start -t AI262 notebooks-collaboration
```
1. Create a small **workbench** called `manage-resources-wb` under `manage-resources` **project**. and Select `Minimal Python` as the **notebook image**.

2. Modify the notebook **available sizes** to add an option called `MediumSmall`,
  - with max `2 CPUs` and `16 Gi` of **memory** and **minimum** `1 CPU` and `16 Gi` **memeory**.

3. Remove the **Large and Xlarge** size. User should not able to see these size when creating a new workbench.

- **Following are the steps:**
4. Clone the `https://github.com/RedHatTraining/AI26X-apps` repository and **use branch** `origin/RHOAI2.13`

5. **Create a Python notebook** called `experiment1.ipynb` that displays a basic scatter plot. Use the below content.

```yaml
import numpy as np
import plotly.express as px

# x-axis data points
x = np.linspace(start=-50, stop=50)

# y-axis data points
y = x ** 2

# define the plot
fig = px.scatter(x=x, y=y)

fig.show()
```
6. Create a new branch called `experiment` and save all the changes.
7. Merge the `experiment` feature branch into the `RHOAI2.13 branch`


### Solution:

**Go to Home** -> APIExplorer -> search for **`odhDashboardConfig`** -> click that by ensuringm, **All Projects** in project filter on top -> click 
  - **Instances** -> click `odh-dashboard-config` -> then you got yaml file -> into that go to **'notebooksizes:`** spec -> edit/modify
  - large as Micro with limits 2 Cpu and 2Gi memory,
  - requests 1 Cpu and 1Gi memory then delete Large and Xlarge, then click **save** further click **reload**



 4. Click `Clone` a Repository.

  - Enter `https://github.com/RedHatTraining/AI26X-apps` as the repository, and click `Clone`.

  - In the JupyterLab file browser, enter the `AI26X-apps` directory.

  - Click the `Git icon`, and change to the `RHOAI2.13` branch by clicking `Current Branch` and selecting `origin/RHOAI2.13`.
  In the JupyterLab file browser, navigate to the `AI26X-apps/intro/notebooks-collaboration` directory and **double click** the `hello.ipynb` notebook to open it.

5. Create a Python notebook called `experiment1.ipynb` that displays a basic scatter plot.
    - **Right-click** the empty canvas of the file browser, and then **click New Notebook**.
    - Alternatively, **click File** and then select **New → Notebook**.
    - In the dialog that opens, select **Python 3.9** as the **kernel**, and click **Select**.
    - Enter the following code in the first cell of the notebook:
      ```yaml
      import numpy as np
      import plotly.express as px

      # x-axis data points
      x = np.linspace(start=-50, stop=50)

      # y-axis data points
      y = x ** 2

      # define the plot
      fig = px.scatter(x=x, y=y)

      fig.show()
      ```

	- Press **Ctrl+S** to save the notebook. Alternatively, you can Click **File → Save Notebook**.
	- A modal window opens to **rename** the notebook file. Enter **`experiment1.ipynb`** and click **Rename**.

6. Commit the changes to a new branch called `experiment`.
- **Click** `Git` icon at left pannel. 
- **Create** a new branch. See the below print screen.

![alt text](<Screenshot 2026-04-12 at 8.18.08 PM.png>)

![Create new Branch](<Screenshot 2026-04-12 at 8.25.35 PM.png>)

- Right click on the file and **Click** `Track`.

![alt text](<Screenshot 2026-04-12 at 8.28.09 PM.png>)

- Then, add summary after that you need to click on `COMMIT`.

- Change the branch to RHOAI2.13 by click on this branch.
- Merge the content of `experiment` to current branch.

![alt text](<Screenshot 2026-04-12 at 8.39.46 PM.png>)