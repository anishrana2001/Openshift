## Task: Install Red Hat OpenShift AI (RHOAI) by using the web console.
## Configure RHOAI components by creating the "Data Science Cluster" (DSC) object.

## Solution:


- Open a web browser `https://console-openshift-console.apps.ocp4.example.com`.
- Use `admin` user and the password is `redhatocp`.


- **Install the RHOAI operator.**

  - Click **Operators** ==> **OperatorHub**. In the Filter by keyword field, type **`openshift`** ai to locate the RHOAI operator, and then ****click****
    `Red Hat OpenShift AI`.
  - Click `Install` to proceed to the Install Operator page.
  - Ensure that the `stable` update channel is selected, and click `Install`.
  - Wait for the RHOAI operator to finish the installation, and then `click` **Create** `DatascienceCluster`.
  - Go to the **YAML** view to read the DataScienceCluster custom resource definition (CRD).
  - FYI `the installed components are defined as Managed. The Removed components are not installed.`
  - Then, click **Create**.
- Install the Red Hat OpenShift **Serverless** operator by using the RHOCP console.
  - Click **Operators** → **OperatorHub**. Search `serverless` to locate the `Red Hat OpenShift Serverless operator`, and then click **Red Hat OpenShift Serverless operator**.

## Verify it.
  - Once it done, `click` on **Installed Operators** ==> Select **Redhat Openshift AI** ==> **Data Science Cluster** ==> **default-dsc** ==> Review the **conditions** 
