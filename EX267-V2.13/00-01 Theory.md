# Red Hat OpenShift AI Documentation: Workbench Pod, Model Pod, and Model Serving Architecture

## 1. Overview

Red Hat OpenShift AI (RHOAI) provides a platform for developing, training, deploying, and serving machine learning and artificial intelligence models on OpenShift. Within RHOAI, two important runtime concepts are commonly used during the machine learning lifecycle:

- **Workbench Pod**
- **Model Pod**

Although both run as pods inside OpenShift, they serve very different purposes. A Workbench pod is mainly used during the development and experimentation stage, while a Model pod is used during the model deployment and inference stage.

Understanding the difference between these two pods is important for designing a clean, scalable, and production-ready AI/ML workflow.

---

## 2. Workbench Pod

### 2.1 What Is a Workbench Pod?

A **Workbench pod** is a development environment provided by Red Hat OpenShift AI. It is mainly used by data scientists, machine learning engineers, and developers to prepare data, write code, experiment with models, and train machine learning workloads.

A workbench typically provides browser-based tools such as:

- JupyterLab
- Code server
- Python notebooks
- Data science libraries
- Custom images and runtime environments

In simple terms, a Workbench pod is where the machine learning work is created, tested, and improved.

### 2.2 Main Purpose of a Workbench Pod

The Workbench pod is used for tasks such as:

| Purpose | Example |
|---|---|
| Data preparation | Cleaning CSV files, transforming datasets, feature engineering |
| Code development | Writing Python scripts, notebooks, or training pipelines |
| Model training | Training models using Scikit-learn, PyTorch, TensorFlow, XGBoost, or other frameworks |
| Experimentation | Testing multiple algorithms or hyperparameters |
| Model evaluation | Checking accuracy, precision, recall, F1-score, or loss metrics |
| Artifact creation | Saving trained models as `.pkl`, `.onnx`, `.pt`, or model folders |

### 2.3 When Is a Workbench Pod Required?

A Workbench pod is useful when the team needs to build, test, or train a model.

However, a Workbench pod is not always required. If a trained model already exists and the goal is only to deploy and serve that model, then a Workbench pod may not be necessary.

For example:

- If a data scientist needs to develop and train a fraud detection model, a Workbench pod is useful.
- If the trained fraud detection model is already available and only needs to be exposed as an API, then model serving can be done without using a Workbench pod.

---

## 3. Model Pod

### 3.1 What Is a Model Pod?

A **Model pod** is the runtime pod responsible for serving a trained model as an API endpoint.

Simple explanation:

> A Model pod is like a production server that loads the trained model and answers prediction requests.

After a model is trained or prepared, it is deployed in RHOAI. Model serving makes the model available as a service or API so that external applications can send input data and receive predictions.

Deploying a model in RHOAI makes it available as a service that can be accessed through API calls.

### 3.2 Main Purpose of a Model Pod

The Model pod is used during the deployment and inference stage. It is responsible for loading the trained model artifact and serving prediction requests from applications, APIs, or end users.

### 3.3 What Does a Model Pod Do?

| Purpose | Example |
|---|---|
| Loading trained model artifacts | Loads `.onnx`, `.pkl`, `.pt`, LLM weights, or model folders |
| Serving prediction API | Exposes endpoints such as `/v1/models/model:predict` or other inference endpoints |
| Handling application requests | A web application sends customer data and receives prediction results |
| Scaling inference | Increases replicas when traffic grows |
| Monitoring runtime behavior | Tracks requests, latency, CPU, memory, and GPU usage |
| Securing access | Supports token-authenticated inference endpoints |

### 3.4 Example Scenario

A data scientist trains a customer churn prediction model in a Workbench pod. The trained model is saved as a model artifact, such as a `.pkl` file.

Later, the model is deployed using RHOAI model serving. At that point, a Model pod starts, loads the `.pkl` file, and exposes an API endpoint. A business application can then send customer data to the API and receive a prediction, such as whether the customer is likely to churn.

---

## 4. Main Difference Between Workbench Pod and Model Pod

| Point | Workbench Pod | Model Pod |
|---|---|---|
| Main role | Development environment | Inference and serving environment |
| Used by | Data scientist or ML engineer | Application, API client, or end user |
| Runs | JupyterLab, code-server, Python notebooks | Model server or serving runtime |
| Purpose | Build, test, train, and experiment | Serve trained model as an API |
| Lifecycle stage | Development and training stage | Deployment and production stage |
| Storage use | Reads and writes datasets, notebooks, scripts, and model files | Reads model artifact and serves it |
| Access method | Browser-based IDE | API endpoint |
| Example | Train a fraud detection model | Predict fraud for a new transaction |

---

## 5. Easy Analogy

A simple way to understand the difference is to compare the machine learning lifecycle with a kitchen and a restaurant counter.

### Workbench Pod = Kitchen

The Workbench pod is like a kitchen.

In the kitchen, the chef prepares the recipe, tests ingredients, adjusts the cooking method, and improves the final dish. Similarly, in a Workbench pod, the data scientist prepares the data, writes code, trains the model, tests different approaches, and creates the final model artifact.

### Model Pod = Restaurant Counter

The Model pod is like a restaurant counter.

At the counter, the final dish is already prepared and customers place orders to receive it quickly. Similarly, in a Model pod, the trained model is already available, loaded into a serving runtime, and ready to respond to prediction requests.

---

## 6. End-to-End RHOAI Workflow

The typical workflow from development to inference can be represented as follows:

```text
Data Scientist
      |
      v
Workbench Pod
(JupyterLab / code-server)
      |
      | Train / test model
      v
Model Artifact
(.pkl / .onnx / .pt / model folder)
      |
      v
Model Pod
(KServe / model server / runtime)
      |
      v
Inference API
      |
      v
Application / User gets prediction
```

### 6.1 Workflow Explanation

1. **Data Scientist starts in the Workbench pod**  
   The data scientist uses JupyterLab or code-server to prepare data, write code, and train the model.

2. **Model is trained and tested**  
   The model is trained using the selected framework, such as Scikit-learn, PyTorch, TensorFlow, or another ML/AI framework.

3. **Model artifact is created**  
   The trained model is saved in a deployable format, such as `.pkl`, `.onnx`, `.pt`, or a model directory.

4. **Model is deployed to model serving**  
   RHOAI deploys the model using a serving platform or runtime, such as KServe, vLLM, OpenVINO, or ModelMesh.

5. **Model pod starts serving predictions**  
   The Model pod loads the model artifact and exposes an inference endpoint.

6. **Applications call the inference API**  
   External systems send input data to the endpoint and receive prediction results.

---

## 7. Model Serving in RHOAI

Model serving is the process of deploying a trained model so it can be accessed by applications through an API.

Instead of running predictions manually inside a notebook, model serving allows the trained model to become part of a production system.

For example, a deployed model can be used by:

- Web applications
- Mobile applications
- Backend services
- Business process systems
- Analytics platforms
- Automation workflows
- Chatbot or generative AI applications

### 7.1 What Happens During Model Serving?

During model serving, RHOAI typically performs the following actions:

1. Reads the model artifact from storage.
2. Starts a serving runtime or model server.
3. Loads the trained model into memory.
4. Exposes an inference API endpoint.
5. Receives input requests from applications.
6. Runs predictions or inference.
7. Sends prediction results back to the client.
8. Supports scaling, monitoring, and secured access.

---

## 8. Comparison of Key Model Servers and Runtimes

RHOAI can work with different model serving components depending on the type of model, performance requirement, and infrastructure.

| Component | Role | Best For | Key Feature |
|---|---|---|---|
| KServe | Orchestrator | High-scale production deployments | Autoscaling: can automatically add or remove resources based on demand |
| vLLM | Runtime | Large Language Models such as Llama, Granite, or similar LLMs | High throughput: uses efficient memory handling techniques such as PagedAttention to serve many users on GPU resources |
| OpenVINO | Runtime | Models running on Intel hardware such as CPUs and GPUs | Efficiency: optimizes models for Intel silicon and improves inference performance |

---

## 9. KServe

### 9.1 What Is KServe?

KServe is a model serving orchestrator commonly used for deploying models in Kubernetes and OpenShift environments.

In RHOAI, KServe is typically used for production-grade model serving where scalability, reliability, and API-based access are important.

### 9.2 Best Use Cases for KServe

KServe is suitable for:

- Production inference services
- Large models requiring dedicated resources
- GPU-based inference workloads
- Models that need autoscaling
- Enterprise applications requiring stable API endpoints

### 9.3 Key Benefit

The key benefit of KServe is that it helps manage model deployment, scaling, and serving behavior in a cloud-native way.

---

## 10. vLLM

### 10.1 What Is vLLM?

vLLM is a serving runtime designed for Large Language Models. It is optimized for high-throughput text generation workloads.

It is commonly used when serving models such as:

- Llama-based models
- Granite models
- Other transformer-based Large Language Models

### 10.2 Best Use Cases for vLLM

vLLM is suitable for:

- Chatbots
- Text generation applications
- Summarization services
- Question-answering systems
- LLM-based assistants
- High-volume inference workloads

### 10.3 Key Benefit

The key benefit of vLLM is that it can serve many users efficiently on GPU infrastructure by using optimized memory management techniques such as PagedAttention.

---

## 11. OpenVINO

### 11.1 What Is OpenVINO?

OpenVINO is a runtime and optimization toolkit designed to improve inference performance, especially on Intel hardware.

It can be used to optimize and serve models originally developed using frameworks such as:

- TensorFlow
- PyTorch
- ONNX
- Other supported model formats

### 11.2 Best Use Cases for OpenVINO

OpenVINO is suitable for:

- CPU-based inference
- Intel GPU-based inference
- Computer vision models
- Traditional machine learning inference
- Optimized edge or enterprise inference workloads

### 11.3 Key Benefit

The main benefit of OpenVINO is inference efficiency. It helps models run faster and more efficiently on Intel hardware.

---

## 12. Single-Model Serving and Multi-Model Serving in RHOAI

RHOAI supports different serving patterns depending on model size, resource requirement, and deployment strategy.

Two common approaches are:

- **Single-Model Serving**
- **Multi-Model Serving**

---

## 13. Single-Model Serving

### 13.1 What Is Single-Model Serving?

Single-model serving means one model is deployed per model server.

This approach is commonly used with KServe and is suitable when a model requires dedicated resources.

### 13.2 Best Use Cases

Single-model serving is best for:

- Large Language Models
- GPU-heavy models
- High-traffic production APIs
- Models requiring isolated scaling
- Critical enterprise services

### 13.3 Example

A company deploys a large LLM for a chatbot. Because the model requires GPU resources and must handle many user requests, it is deployed using single-model serving.

In this case:

- One model gets its own serving runtime.
- The deployment can scale independently.
- GPU resources can be assigned specifically to that model.

---

## 14. Multi-Model Serving

### 14.1 What Is Multi-Model Serving?

Multi-model serving allows multiple smaller models to be packed into one serving environment.

In RHOAI, ModelMesh is commonly associated with this pattern.

### 14.2 Best Use Cases

Multi-model serving is best for:

- Smaller traditional machine learning models
- Cost-sensitive deployments
- Many models with moderate traffic
- Batch-style or occasional inference use cases
- Models that do not require dedicated GPU resources

### 14.3 Example

A financial services company has many smaller models for:

- Fraud detection
- Credit risk scoring
- Loan approval prediction
- Customer churn prediction
- Transaction classification

Instead of giving each model its own dedicated server, multiple models can be served using a shared model serving infrastructure. This helps reduce cost and improve resource utilization.

---

## 15. Single-Model Serving vs Multi-Model Serving

| Point | Single-Model Serving | Multi-Model Serving |
|---|---|---|
| Deployment pattern | One model per server | Multiple models per server |
| Common component | KServe | ModelMesh |
| Best for | Large, heavy, production models | Smaller traditional ML models |
| Resource usage | Dedicated resources | Shared resources |
| Cost efficiency | Higher cost, better isolation | Lower cost, better consolidation |
| Scaling | Scales per model | Scales shared serving infrastructure |
| Example | LLM chatbot using GPU | Fraud, churn, and risk models served together |

---

## 16. Practical Example: Fraud Detection Model

### 16.1 Development Stage

A data scientist creates a fraud detection model using a Workbench pod.

Tasks performed in the Workbench pod may include:

- Loading transaction data
- Cleaning missing values
- Creating features
- Training a classification model
- Testing model accuracy
- Saving the trained model as a `.pkl` or `.onnx` file

### 16.2 Deployment Stage

After the model is trained, it is deployed into RHOAI model serving.

A Model pod is created to:

- Load the trained fraud detection model
- Expose a prediction endpoint
- Receive transaction data from an application
- Return a fraud or non-fraud prediction

### 16.3 Inference Stage

An application sends a new transaction to the inference API.

Example request flow:

```text
Banking Application
      |
      v
Fraud Detection API Endpoint
      |
      v
Model Pod loads fraud model
      |
      v
Prediction returned
      |
      v
Application marks transaction as low-risk or high-risk
```

---

## 17. Practical Example: Large Language Model

### 17.1 Development or Preparation Stage

A team prepares or fine-tunes a Large Language Model using a Workbench pod or another training environment.

The model artifact may include:

- Model weights
- Tokenizer files
- Configuration files
- Model folder structure

### 17.2 Deployment Stage

The LLM is deployed using a serving runtime such as vLLM.

The Model pod:

- Loads the LLM weights
- Allocates GPU resources
- Exposes an inference endpoint
- Handles text generation requests

### 17.3 Inference Stage

A chatbot application sends a prompt to the model endpoint. The Model pod processes the request and returns generated text.

---

## 18. Storage Considerations

Storage plays an important role in the movement from development to serving.

### 18.1 Workbench Pod Storage Usage

A Workbench pod may read and write:

- Raw datasets
- Cleaned datasets
- Notebooks
- Python scripts
- Experiment outputs
- Trained model artifacts

### 18.2 Model Pod Storage Usage

A Model pod usually reads model artifacts from storage and loads them into the serving runtime.

A Model pod generally does not perform model training. Its primary job is to serve the model for inference.

---

## 19. Access Method

### 19.1 Workbench Pod Access

A Workbench pod is usually accessed through a browser-based development interface.

Examples:

- JupyterLab URL
- Code-server URL
- Notebook interface

This access is intended for developers, data scientists, or ML engineers.

### 19.2 Model Pod Access

A Model pod is accessed through an API endpoint.

Applications or users do not usually interact with the Model pod through a notebook interface. Instead, they send API requests to the inference endpoint and receive prediction responses.

---

## 20. Monitoring and Scaling

### 20.1 Monitoring Model Pods

Model pods are important in production because they directly serve user or application requests. Common monitoring areas include:

- Number of requests
- Request latency
- Error rate
- CPU usage
- Memory usage
- GPU usage
- Pod health
- Replica count

### 20.2 Scaling Model Pods

When traffic increases, model serving deployments may need to scale.

Scaling can involve:

- Increasing pod replicas
- Allocating more CPU or memory
- Assigning GPU resources
- Using autoscaling policies
- Separating heavy models into dedicated deployments

---

## 21. Security Considerations

Model serving endpoints may expose sensitive prediction capabilities or business logic. Therefore, access should be controlled.

Common security practices include:

- Token-based authentication
- Role-based access control
- Network policies
- Secured routes
- TLS-enabled communication
- Restricting access to authorized applications
- Monitoring API usage

A Workbench pod should also be secured because it may contain datasets, notebooks, credentials, and training artifacts.

---

## 22. Recommended Usage Pattern

A clean RHOAI lifecycle usually follows this pattern:

1. Use a Workbench pod for development.
2. Prepare and clean the data.
3. Train and evaluate the model.
4. Save the trained model artifact.
5. Deploy the model using RHOAI model serving.
6. Run the model inside a Model pod.
7. Expose the model through an inference API.
8. Connect business applications to the inference endpoint.
9. Monitor, scale, and secure the deployed model.

---

## 23. Summary

A Workbench pod and a Model pod are both important in Red Hat OpenShift AI, but they are used for different stages of the AI/ML lifecycle.

The **Workbench pod** is used to build, test, train, and experiment with models. It is mainly used by data scientists and ML engineers through tools such as JupyterLab or code-server.

The **Model pod** is used to serve the trained model as an API. It is mainly used by applications, API clients, or end users who need predictions from the model.

In simple terms:

- **Workbench Pod = development and training environment**
- **Model Pod = production inference and serving environment**

Together, they support the full journey from model development to production deployment in RHOAI.

---

## 24. Final Key Takeaway

The Workbench pod is where the model is created, trained, and tested. The Model pod is where the trained model runs in production and responds to prediction requests.

Using the right pod for the right stage helps teams build reliable, scalable, and secure AI/ML solutions on Red Hat OpenShift AI.

