# Q2 Change the workbench size.

## How to prepare the lab?
#### LAB NAME: Guided Exercise: Managing Resources

```
lab start -t AI263 manage-resources
```
- Create a small **workbench** called `manage-resources-wb` under `manage-resources` **project**.
- Select `Minimal Python` as the **notebook image**.
- Modify the notebook **available sizes** to add an option called `MediumSmall`,
  - with max `2 CPUs` and `16 Gi` of **memory** and **minimum** `1 CPU` and `16 Gi` **memeory**.
- Remove the **Large and Xlarge** size. User should not able to see these size when creating a new workbench.
---

### Solution:

**Go to Home** -> APIExplorer -> search for **`odhDashboardConfig`** -> click that by ensuringm, **All Projects** in project filter on top -> click 
  - **Instances** -> click `odh-dashboard-config` -> then you got yaml file -> into that go to **'notebooksizes:`** spec -> edit/modify
  - large as Micro with limits 2 Cpu and 2Gi memory,
  - requests 1 Cpu and 1Gi memory then delete Large and Xlarge, then click **save** further click **reload**
