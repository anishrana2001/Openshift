

<img width="1216" height="1294" alt="05_Tekton" src="https://github.com/user-attachments/assets/5fb5fa9b-d1f2-4b8f-82f3-a21e810dfe43" />



# Tekton & OpenShift Pipelines - Beginner Practice Questions
## Level 1: Understanding the Foundation

---

# Question 1: Why do we need Tekton?

## Scenario

A development team manually performs the following steps every time they release an application:

1. Download source code from Git
2. Install dependencies
3. Run tests
4. Build a container image
5. Deploy the application to OpenShift

After several months, developers complain that:
- Deployments take too much time
- Different developers follow different processes
- Human mistakes frequently break deployments

The team decides to implement Tekton.

## Question

What is the primary purpose of Tekton in this situation?

A) Replace Kubernetes with a new container platform

B) Provide a cloud-native framework to automate CI/CD workflows

C) Store application source code

D) Replace container images with virtual machines


## Correct Answer

B


## Explanation

Tekton is a cloud-native CI/CD framework that helps automate software delivery workflows.

Instead of developers manually executing every step, Tekton creates reusable automation blocks.

Typical workflow:

Git Code
   |
   v
Build
   |
   v
Test
   |
   v
Create Image
   |
   v
Deploy


Remember:

Tekton = Automation engine for CI/CD pipelines


---

# Question 2: Understanding Tekton Building Blocks

## Scenario

A developer creates a CI/CD workflow:

Step 1:
Clone source code from Git

Step 2:
Run unit tests

Step 3:
Build container image


The developer wants to organize these actions correctly using Tekton concepts.

## Question

Which Tekton structure should contain multiple commands such as cloning code, testing, and building?

A) Step

B) Task

C) PipelineRun

D) Workspace


## Correct Answer

B


## Explanation

A Task is a reusable building block containing one or more Steps.

Relationship:

Step
 |
 | contains one command
 |
 v

Task
 |
 | contains multiple steps
 |
 v

Pipeline
 |
 | combines multiple tasks


Example:

Task:
Run Tests

Steps:

1. npm install
2. npm test
3. npm lint


A Task usually executes inside a Kubernetes Pod.


---

# Question 3: Task vs Pipeline

## Scenario

A company has created these reusable Tasks:

Task 1:
Clone Git repository

Task 2:
Run security scan

Task 3:
Build container image

Task 4:
Deploy application


The company wants to create a complete application delivery workflow.

## Question

Which Tekton object should combine these Tasks into one workflow?

A) Step

B) Secret

C) Pipeline

D) TaskRun


## Correct Answer

C


## Explanation

A Pipeline defines the order and relationship between Tasks.

Example:

Pipeline: Application Deployment


        Clone Code
             |
             v

        Security Scan
             |
             v

        Build Image
             |
             v

        Deploy Application


Pipeline decides:

- Which Tasks run
- Task execution order
- Dependencies between Tasks


---

# Question 4: Understanding PipelineRun and TaskRun

## Scenario

A Pipeline named:

java-build-pipeline

contains three Tasks:

1. Git clone
2. Maven build
3. Container image creation


A developer starts this pipeline using:

tkn pipeline start java-build-pipeline


## Question

What resources are automatically created by Tekton to execute this pipeline?

A) Only Kubernetes Deployment objects

B) PipelineRun and TaskRun objects

C) Only Pod objects

D) Docker containers directly


## Correct Answer

B


## Explanation

Tekton separates:

Pipeline Definition
        |
        v

PipelineRun
        |
        v

Actual execution


When a Pipeline starts:

PipelineRun is created.

For each Task inside the Pipeline:

TaskRun objects are created.


Example:


PipelineRun
     |
     |
     +---- TaskRun 1
     |
     +---- TaskRun 2
     |
     +---- TaskRun 3



Remember:

Pipeline = Blueprint

PipelineRun = Actual execution


---

# Question 5: Automatic Pipeline Execution Using Triggers

## Scenario

A company wants this automation:

Developer pushes code to GitHub.

Automatically:

1. Start testing pipeline
2. Build container image
3. Deploy application


No developer should manually start the pipeline.


## Question

Which Tekton feature should be used?

A) Workspace

B) Trigger

C) TaskRun

D) Parameter


## Correct Answer

B


## Explanation

Triggers allow pipelines to start automatically based on external events.

Common events:

- Git push
- Pull request
- Webhook


Flow:


Developer
    |
    |
    v

Git Push Event

    |
    |
    v

Tekton Trigger

    |
    |
    v

PipelineRun Created

    |
    |
    v

Pipeline Executes



Triggers connect external events with CI/CD automation.


---

# EX288 Exam Connection

The EX288 exam expects candidates to understand:

✓ OpenShift Pipelines architecture

✓ Tekton custom resources

✓ Creating and working with Tasks

✓ Creating and working with Pipelines

✓ Running and troubleshooting Pipeline workflows

✓ Configuring triggers for application workflows


Study order:

1. Understand CI/CD concepts
2. Learn Tekton objects
3. Create Tasks
4. Create Pipelines
5. Execute PipelineRuns
6. Troubleshoot failures


## Memory Trick

Remember:

S → T → P → R


Step

↓


Task

↓


Pipeline

↓


Run


Meaning:

Step = Single action

Task = Group of actions

Pipeline = Complete workflow

Run = Actual execution


---

## Next Practice Set

Coming next:

- Task YAML questions
- Pipeline YAML questions
- Workspace questions
- Buildah image build pipeline questions
- OpenShift tkn CLI questions
- EX288 troubleshooting scenarios
