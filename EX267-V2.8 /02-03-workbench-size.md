# Q2 Change the workbench size.

## How to prepare the lab?
#### LAB NAME: Guided Exercise: Managing Resources

```
lab start -t AI263 manage-resources
lab start -t AI262 notebooks-collaboration
```
1. Create a small **workbench** called `manage-resources-wb` under `manage-resources` **project**. and Select `Standard Data Science` as the **notebook image**.
2. Modify the notebook **available sizes** to add an option called `MediumSmall`,
  - with max `2 CPUs` and `16 Gi` of **memory** and **minimum** `1 CPU` and `16 Gi` **memeory**.
3. Remove the **Large and Xlarge** size. Users should not able to see these size when creating a new workbench.
4. Once the workbench started, **Clone** the `https://github.com/RedHatTraining/AI26X-apps` repository and **use branch** `origin/RHOAI2.13`
5. **Create a Python notebook** called `experiment1.ipynb` that displays a basic scatter plot. Use the below content.

```python
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
In order to complete this question, first we need to modify the size. Thus, start with Step 2.

Step 2. 

**Navigate to Home** → **APIExplorer**
Search for **`odhDashboardConfig`**
Click Instances → **odh-dashboard-config**
Edit the notebook sizes in the **YAML**
then you got yaml file -> into that go to **'notebooksizes:`** spec -> edit/modify as per the question.
Step 3. delete Large and Xlarge, then click **save** further click **reload**

Step 1. Now, we can create a workbench which is asked in step 1.

Step 4. Click `Clone` a Repository.

	 - Enter `https://github.com/RedHatTraining/AI26X-apps` as the repository, and click `Clone`.
	 - In the JupyterLab file browser, enter the `AI26X-apps` directory.
	 - Click the `Git icon`, and change to the `RHOAI2.13` branch by clicking `Current Branch` and selecting `origin/RHOAI2.13`.
	 - In the JupyterLab file browser, navigate to the `AI26X-apps/intro/notebooks-collaboration` directory and **double click** the `hello.ipynb` notebook to open it.

Step 5. Create a Python notebook called `experiment1.ipynb` that displays a basic scatter plot.
    - **Right-click** the empty canvas of the file browser, and then **click New Notebook**.
    - Alternatively, **click File** and then select **New → Notebook**.
    - In the dialog that opens, select **Python 3.9** as the **kernel**, and click **Select**.
    - Enter the following code in the first cell of the notebook:
      ```python
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

Step 6. Commit the changes to a new branch called `experiment`.
- **Click** `Git` icon at left panel. 
- **Create** a new branch. See the below print screen.
Step 1. 
![alt text](<Screenshot 2026-04-12 at 8.18.08 PM.png>)

Step 2.
![Create new Branch](<Screenshot 2026-04-12 at 8.25.35 PM.png>)

- Right click on the file and **Click** `Track`.

![alt text](<Screenshot 2026-04-12 at 8.28.09 PM.png>)

- Then, add summary after that you need to click on `COMMIT`.

- Change the branch to RHOAI2.13 by click on this branch.
- Merge the content of `experiment` to current branch.

![alt text](<Screenshot 2026-04-12 at 8.39.46 PM.png>)
