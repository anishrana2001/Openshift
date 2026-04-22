# 🚀 Model Serving API – End-to-End Lab (EX267 Level)

## 🎯 Objective

Deploy an AI model using **Multi-Model Serving** and consume it via API using authentication.

# ⚙️ Lab Setup
###      ▶️ Start Environment

```bash
lab start -t AI265 rhoaiserving-consuming
```
---

# 🧩 Question

**Using Model servers to deploy and consume a model**

You need to work in the existing project `rhoaiserving-consuming` and deploy the `iris` model to a multi-model server, then send an inference request to it.

- Use the **Multi-model serving platform**:
  - Model server name: `infer-model-server`
  - Serving runtime: **OpenVINO Model Server**
  - The model server **must be available through an external route**
  - **Token authentication is required**
    - Service account name: `infer-serviceaccount`
- Deploy the model with:
  - Model name: `iris`
  - Model framework (name - version): `onnx - 1`
  - Use an **existing data connection**:
    - Data connection: `s3-minio`
    - Path: `iris`
- After deployment:
  - Export the model URL (without `/infer`) to an environment variable named `MODEL_PATH`
  - Export the token secret value to an environment variable named `TOKEN`
- Use `curl` with `MODEL_PATH` and `TOKEN` to:
  - Retrieve the model metadata
  - Call the `/infer` endpoint with an input tensor (`X` with shape `[1,4]` and datatype `FP32`) and observe the prediction scores.

---

Your tasks:

✅ Deploy model on **Multi-Model Server**
✅ Enable **External Route + Token Authentication**
✅ Call API using `curl`
✅ Validate prediction output

---



---

# 🌐 Step 1: Open RHOAI Dashboard

* URL:

  ```
  https://rhods-dashboard-redhat-ods-applications.apps.ocp4.example.com
  ```

* Login:

  * Username: `developer`
  * Password: `developer`

---

# 📂 Step 2: Open Project

* Navigate to: **Data Science Projects**
* Select: `rhoaiserving-consuming`

 
---

# 🧠 Step 3: Create Model Server

Go to **Models → Multi-model serving platform → Add model server**

### Fill Details:

| Field                | Value                  |
| -------------------- | ---------------------- |
| Model Server Name    | `infer-model-server`   |
| Runtime              | OpenVINO Model Server  |
| External Route       | ✅ Enabled              |
| Token Authentication | ✅ Enabled              |
| Service Account      | `infer-serviceaccount` |

👉 Click **Add**

⏳ Wait 2–3 minutes for deployment

---

# 🤖 Step 4: Deploy Model

Click **Deploy model** and fill:

| Field           | Value      |
| --------------- | ---------- |
| Model Name      | `iris`     |
| Framework       | `onnx - 1` |
| Data Connection | `s3-minio` |
| Path            | `iris`     |

👉 Click **Deploy**

---

# 🔐 Step 5: Export Variables

## 🔹 Export MODEL_PATH

Copy inference URL (without `/infer`):

```bash
export MODEL_PATH=https://iris-rhoaiserving-consuming.apps.ocp4.example.com/v2/models/iris
```

---

## 🔹 Export TOKEN

Copy token from dashboard:

```bash
export TOKEN=your-token-here
```

---

# 🔍 Step 6: Get Model Metadata

```bash
curl -s \
  -H "Authorization: Bearer $TOKEN" \
  "$MODEL_PATH" | jq
```

### ✅ Expected Output

* Model name
* Inputs (`X`, shape `[1,4]`)
* Outputs (`label`, `scores`)

✔️ Confirms model is deployed

---

# 🔥 Step 7: Run Inference

## 📤 Send Request

```bash
curl -s \
  -H "Authorization: Bearer $TOKEN" \
  "$MODEL_PATH/infer" \
  -X POST \
  --data '{
    "inputs":[
      {
        "name":"X",
        "shape":[1,4],
        "datatype":"FP32",
        "data":[5.1,3.5,1.4,0.2]
      }
    ]
  }' | jq
```

---

## 📥 Sample Output

```json
{
  "outputs": [
    {
      "name": "label"
    },
    {
      "name": "scores",
      "data": [3.12, 4.82, 3.48]
    }
  ]
}
```

---

## 🧠 Interpretation

* `scores` → probability for each class
* `label` → predicted class index

---

# 🧪 Bonus: Workbench Execution

1. Go to **Workbenches**
2. Open: `infer-wb`
3. Navigate to:

```bash
AI26X-apps/deploying/rhoaiserving-consuming/inference-request.ipynb
```

4. Run notebook for automated inference

---

# ⚠️ Common Mistakes

❌ Using `/infer` in MODEL_PATH
❌ Missing token header
❌ Wrong JSON format
❌ Model not fully deployed

---

# 🔥 Exam Tips (VERY IMPORTANT)

👉 Always:

```bash
echo $MODEL_PATH
echo $TOKEN
```

👉 Test API before submission

👉 Check model status in dashboard

---

# ✅ Summary

* Deployed model using OpenVINO server
* Secured with token authentication
* Called API using curl
* Verified predictions

---

# 🧹 Cleanup

```bash
lab finish rhoaiserving-consuming
```

---

# 🚀 Next Step

➡️ Practice same flow with another model
➡️ Try different input values
➡️ Automate using scripts

---


