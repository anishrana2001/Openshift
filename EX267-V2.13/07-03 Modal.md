# 🚀 Question 7. How to create models ? – End-to-End Lab (EX267 Level)

## How to create lab?
```
lab start -t AI265 serving-saving
lab start -t AI265 rhoaiserving-using

oc -n rhoai-multimodel get secret aws-connection-rhoaiserving-using -o json  | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"' > /tmp/S3file

cat /tmp/S3file | awk ' 
/AWS_ACCESS_KEY_ID/   { print $0 }
/AWS_SECRET_ACCESS_KEY/ { print $0 } 
/AWS_DEFAULT_REGION/   { print $0 }
/AWS_S3_ENDPOINT/      { print $0 }'  > /tmp/.s3cfg
```
# 🧩 Task: Using Model servers to deploy Model. 
- You need to create project `tiger` and then Deploy the `diabetes` model in this project. 
- Use `Multi-model` serving platform:
	- Model server name: `multimodel-server`
	- Serving runtime: `OpenVINO Model Server`
	- It should be available through an external route.
	- token authorization is not required.
		- Model name: `diabetes`
		- Model framework (name - version): `onnx - 1`
		- Create a new `data connection` by using the file `/tmp/.s3cfg`
			- Name: `rhoaiserving-using`
			- Path: `models/diabetes`
            - **`s3://models-bucket/myfile.onnx`**

Your tasks:

✅ Deploy model on **Multi-Model Server**

✅ Enable **External Route + Without Token**




# 🧩  Step-by-Step Solution: Deploy `diabetes` Model on Multi-Model Server

## Lab Creation

Run the lab setup commands:

```bash
lab start -t AI265 serving-saving
lab start -t AI265 rhoaiserving-using

## Create the S3 configuration file:

oc -n rhoai-multimodel get secret aws-connection-rhoaiserving-using -o json \
| jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"' > /tmp/S3file

## Filter only the required S3 details:

cat /tmp/S3file | awk '
/AWS_ACCESS_KEY_ID/   { print $0 }
/AWS_SECRET_ACCESS_KEY/ { print $0 }
/AWS_DEFAULT_REGION/   { print $0 }
/AWS_S3_ENDPOINT/      { print $0 }' > /tmp/.s3cfg
```

## Verify the file:
``
cat /tmp/.s3cfg
``

### You should see values similar to:
```
AWS_ACCESS_KEY_ID: <access-key>
AWS_SECRET_ACCESS_KEY: <secret-key>
AWS_DEFAULT_REGION: <region>
AWS_S3_ENDPOINT: <endpoint-url>
```

## Task: Using Model Servers to Deploy Model

- You need to create the project **`tiger`** and deploy the **`diabetes`** model by using the **`multi-model`** serving platform.

#### Required configuration:


# Model Deployment Configuration: Tiger Project

This document outlines the deployment configuration for the `diabetes` model within the RHOAI multi-model serving environment.

## Deployment Specifications

| Attribute | Configuration Value |
| :--- | :--- |
| **Project Name** | `tiger` |
| **Serving Platform** | Multi-model |
| **Model Server Name** | `multimodel-server` |
| **Serving Runtime** | OpenVINO Model Server |
| **External Route** | Enabled |
| **Token Authorization** | Disabled |
| **Model Name** | `diabetes` |
| **Model Framework** | `onnx - 1` |
| **Data Connection** | `rhoaiserving-using` |
| **S3 Bucket** | `models-bucket` |
| **Model Path** | `models/diabetes` |
| **Model File Source** | `s3://models-bucket/myfile.onnx` |

## Setup and Verification

1. **Environment Setup:** Execute the prescribed `lab start` commands to initialize the serving environment.
2. **Connectivity:** Ensure the `rhoaiserving-using` data connection is correctly mapped to the `models-bucket` using the retrieved S3 credentials.
3. **Deployment:** Configure the `multimodel-server` via the RHOAI dashboard, ensuring the external route is active and authentication is omitted.
4. **Validation:** Verify the status of the `diabetes` model in the dashboard until the "Available" state is confirmed.


### Step 1: Open Red Hat OpenShift AI Dashboard
1. Open the OpenShift web console.
2. Open Red Hat OpenShift AI.
3. Go to Data Science Projects.


### Step 2: Create Project tiger

1. Click Create data science project.
2. Enter the following details:

|Field|	Value|
| :--- | :--- |
|Name	|tiger|
|Resource name|	tiger|

3. Click Create.


### Step 3: Create Data Connection

**Inside the tiger project:**

1. Go to Data connections.
2. Click Add data connection.
3. Select S3 compatible object storage.
4. Fill in the values from /tmp/.s3cfg.

#### Use these details:

  | Field | Value |
  | :---- | :---- |
  | **Name** | `rhoaiserving-using` |
  | **Access Key** | Value of `AWS_ACCESS_KEY_ID` |
  | **Secret Key** | Value of `AWS_SECRET_ACCESS_KEY` |
  | **Endpoint** | Value of `AWS_S3_ENDPOINT` |
  | **Region** | Value of `AWS_DEFAULT_REGION` |
  | **Bucket** | `models-bucket` |


**5. Click Add data connection.**


### Step 4: Create Multi-Model Server

**Inside the tiger project:**

1. Go to Models.
2. Click Deploy model.
3. Select Multi-model serving platform.
4. Create a new model server.

Use this configuration:

| Field | Value |
| :--- | :--- |
| **Model server name** | `multimodel-server` |
| **Serving runtime** | OpenVINO Model Server |
| **External route** | Enabled |
| **Token authorization** | Disabled |

5. Click Deploy or Create model server.


### Step 5: Deploy the diabetes Model

**After the model server is created:**

1. Go to Models.
2. Click Deploy model.
3. Select the existing model server: **`multimodel-server`**

4. Enter the model details:

| Field | Value |
| :--- | :--- |
| **Model name** | `diabetes` |
| **Model framework** | `onnx - 1` |
| **Data connection** | `rhoaiserving-using` |
| **Path** | `models/diabetes` |
| **Model source** | `s3://models-bucket/myfile.onnx` |



**Important:**

If the dashboard asks for the model folder path, enter only: **`models/diabetes`**

Do not enter the full S3 URL in the path field unless the UI specifically asks for the full URI.

5. Click Deploy.

### Step 6: Verify Deployment

### Switch to the project:
```
oc project tiger
```
### Check pods:
```
oc get pods
```
### Expected result:
- multimodel-server pod should be Running

### Check route:
```
oc get routes
```

### Expected result:

- External route should be available

- Check inference service:
```
oc get isvc
```

### or:
```
oc get inferenceservice
```

### Expected result:

diabetes model should be listed
- Describe the model:
```
oc describe isvc diabetes
```

### Step 7: Check Model Server Logs

If the model is not ready, check logs.

#### First get the pod name:
```
oc get pods
```
Then run:
```
oc logs <multimodel-server-pod-name>
```

#### Example:
```
oc logs multimodel-server-xxxxx
```

### Step 8: Test External Route

Get the route:
```
oc get routes
```
Copy the external route URL.

Check model metadata:
```
curl -k https://<route-url>/v2/models/diabetes/metadata
```
If metadata works, test inference:
```
curl -k -X POST https://<route-url>/v2/models/diabetes/infer \
-H "Content-Type: application/json" \
-d '{
  "inputs": [
    {
      "name": "float_input",
      "shape": [1, 8],
      "datatype": "FP32",
      "data": [6,148,72,35,0,33.6,0.627,50]
    }
  ]
}'
```

Note:

The input name may be different. Always confirm the input name from metadata:
```
curl -k https://<route-url>/v2/models/diabetes/metadata
```
Common Error: Internal Server Error

If you get:

{"detail":"Internal Server Error"}

Check the following:

1. Confirm model status
oc get isvc

The model should show Ready.

2. Check pod logs
oc logs <multimodel-server-pod-name>
3. Confirm S3 path

Expected S3 structure:

models-bucket/
└── models/
    └── diabetes/
        └── myfile.onnx

Then the dashboard path should be:

models/diabetes
4. Confirm external route
oc get routes

The external route should exist.

5. Confirm token authorization is disabled

If token authorization is enabled, edit the model server and disable it.

Final Checklist

Before submitting, confirm:

 Lab started successfully.
 /tmp/.s3cfg created.
 Project tiger created.
 Data connection rhoaiserving-using created.
 Multi-model serving platform selected.
 Model server name is multimodel-server.
 Runtime is OpenVINO Model Server.
 External route is enabled.
 Token authorization is disabled.
 Model name is diabetes.
 Framework is onnx - 1.
 Path is models/diabetes.
 Model is deployed successfully.
 Model status is Ready or Loaded.

EOF


After running it, check that the file exists:

```bash
ls -l solution.md

Open it with:

cat solution.md