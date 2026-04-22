# 🛠️ RHOAI Installation on OpenShift

## 🎯 Objective

Install Red Hat OpenShift AI using OperatorHub.

---

## 📋 Prerequisites

* OpenShift Cluster access
* Cluster Admin permissions
* Internet access

---

## 🚀 Step-by-Step Installation

### 🔹 Step 1: Login to OpenShift

* Open a web browser: 
  👉  `https://console-openshift-console.apps.ocp4.example.com`
  - Use the `admin` user and the password `redhatocp`.

### 🔹 If you observe any issue, you can execute the below command. This lab will ensure that RHOCP is not pre-installed.
```bash
lab start -t AI263 rhoai-install
```
---

### 🔹 Step 2: Open OperatorHub

* Go to OpenShift Web Console
* Navigate to:
  👉 Operators → OperatorHub

---

### 🔹 Step 3: Search for RHOAI

* Search: **OpenShift AI**
* Select the operator `Redhat Openshift AI`

---

### 🔹 Step 4: Install Operator

* Click **Install**
* Choose:

  * `All namespaces`
  * **Automatic updates**

---

### 🔹 Step 5: Create `DataScienceCluster`

* Go to the **YAML** view to read the `DataScienceCluster` custom resource definition (CRD).
  👉 FYI: the installed components are defined as **Managed**. The removed components are not installed.
* Then, Click **Create**.

---

### 🔹 Step 6: Install the Red Hat OpenShift `Serverless` operator

* Click **Operators** → **OperatorHub**.
* Search `serverless` to locate the **Red Hat OpenShift Serverless operator**, and then **Click** it.

## Post checks / ✅ Verify the installation

- ✅ Once it is done:
  - Click **Installed Operators**.
  - Select **Red Hat OpenShift AI**.
  - Go to **Data Science Cluster** → **default-dsc**.
  - Review the **Conditions**.

## 🧪 CLI Alternative (IMPORTANT), just a hint

```bash
oc get operators
oc get csv -A
```

---

## ⚠️ Common Mistakes

* Not selecting correct namespace
* Missing permissions
* Operator not fully installed

---

## 🔥 Exam Tip

👉 Always verify installation using:

```bash
oc get pods -n redhat-ods-applications
```

---

## ✅ Summary

* Installed via OperatorHub
* Requires admin access
* Must verify pods running

---

➡️ Next: Verification & Usage
