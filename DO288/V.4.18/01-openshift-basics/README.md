# Red Hat Certified Specialist in OpenShift Application Development (EX288)

## OpenShift 4.18 / DO288 Complete Hands-On Learning Course

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-red)
![Certification](https://img.shields.io/badge/Certification-EX288-blue)

------------------------------------------------------------------------

# Welcome to EX288 Application Development Course

This repository is a complete hands-on learning platform for preparing
for:

**Red Hat Certified Specialist in OpenShift Application Development
(EX288)**

The objective of this course is to take a student from:

    Linux Beginner
            |
            v
    Container Fundamentals
            |
            v
    OpenShift Application Deployment
            |
            v
    Image Builds & ImageStreams
            |
            v
    S2I Application Development
            |
            v
    CI/CD with Tekton Pipelines
            |
            v
    EX288 Certified Developer

This course focuses on practical implementation rather than only theory.

------------------------------------------------------------------------

# Course Objectives

After completing this course, students will understand:

-   OpenShift projects and applications
-   Container image creation
-   ImageStreams
-   BuildConfigs
-   Source-to-Image (S2I)
-   Deployments and Pods
-   Application configuration
-   Security and RBAC
-   Routes and Services
-   Tekton CI/CD pipelines

------------------------------------------------------------------------

# Application Lifecycle Covered

``` mermaid
flowchart LR

A[Application Source Code]
-->B[Container Build]

B-->C[Container Image]

C-->D[Image Registry]

D-->E[OpenShift ImageStream]

E-->F[Deployment]

F-->G[ReplicaSet]

G-->H[Pods]

H-->I[OpenShift Route]
```

------------------------------------------------------------------------

# Course Modules

## Module 01 - OpenShift Application Development Fundamentals

Folder:

    01-openshift-basics/

Topics:

-   What is OpenShift
-   Kubernetes vs OpenShift
-   OpenShift Architecture
-   Projects and Namespaces
-   oc CLI
-   Authentication
-   Developer workflow

------------------------------------------------------------------------

## Module 02 - Container Images Fundamentals

Folder:

    02-container-images/

Topics:

-   Container concepts
-   Dockerfile
-   Image layers
-   Base images
-   Podman
-   Container registries
-   Image security

Workflow:

    Application Code
            |
            v
    Dockerfile
            |
            v
    podman build
            |
            v
    Container Image
            |
            v
    Registry

------------------------------------------------------------------------

## Module 03 - OpenShift ImageStreams

Folder:

    03-imagestreams/

Topics:

-   ImageStream
-   ImageStreamTag
-   Internal registry
-   External registry
-   Image triggers
-   Deployment integration

------------------------------------------------------------------------

## Module 04 - BuildConfig and S2I

Folder:

    04-buildconfig-s2i/

Topics:

-   BuildConfig
-   Build strategies
-   Source-to-Image
-   Builder images
-   Build pods
-   Application builds

------------------------------------------------------------------------

## Module 05 - Deployments and Application Lifecycle

Folder:

    05-deployments-pods/

Topics:

-   Deployments
-   DeploymentConfig
-   ReplicaSets
-   Pods
-   Rolling updates
-   Rollbacks
-   Troubleshooting

Commands:

``` bash
oc get pods
oc describe pod <pod-name>
oc logs <pod-name>
oc debug pod/<pod-name>
```

------------------------------------------------------------------------

## Module 06 - Configuration and Security

Folder:

    06-config-security/

Topics:

-   ConfigMaps
-   Secrets
-   Environment variables
-   Volumes
-   ServiceAccounts
-   RBAC
-   Roles
-   RoleBindings

------------------------------------------------------------------------

## Module 07 - Networking and Advanced Deployment

Folder:

    07-networking/

Topics:

-   Services
-   Routes
-   Networking
-   Health probes
-   Resource limits
-   Autoscaling

------------------------------------------------------------------------

## Module 08 - Tekton CI/CD Pipelines

Folder:

    08-tekton-pipelines/

Topics:

-   Tekton architecture
-   Tasks
-   TaskRuns
-   Pipelines
-   PipelineRuns
-   Workspaces
-   Triggers

Pipeline:

    Developer Commit
            |
            v
    Git Repository
            |
            v
    Tekton Pipeline
            |
            v
    Build Image
            |
            v
    Push Registry
            |
            v
    Update ImageStream
            |
            v
    Deploy Application

------------------------------------------------------------------------

## Module 09 - EX288 Practice Labs

Folder:

    09-ex288-practice-labs/

Labs:

1.  Deploy application from image
2.  Create ImageStream
3.  Create BuildConfig and S2I application
4.  Configure Secrets and ConfigMaps
5.  Build Tekton CI/CD pipeline

------------------------------------------------------------------------

# Repository Structure

    DO288/
    |
    ├── README.md
    |
    ├── 01-openshift-basics/
    ├── 02-container-images/
    ├── 03-imagestreams/
    ├── 04-buildconfig-s2i/
    ├── 05-deployments-pods/
    ├── 06-config-security/
    ├── 07-networking/
    ├── 08-tekton-pipelines/
    ├── 09-ex288-practice-labs/
    |
    └── diagrams/

------------------------------------------------------------------------

# Learning Methodology

    Understand
        |
    Deploy
        |
    Troubleshoot
        |
    Automate
        |
    Master

------------------------------------------------------------------------

# Environment Requirements

Recommended:

-   OpenShift Container Platform 4.18
-   OpenShift Local
-   oc CLI
-   Podman
-   Git
-   VS Code

------------------------------------------------------------------------

# EX288 Preparation Checklist

Students should be able to:

-   Build container images
-   Deploy applications
-   Manage ImageStreams
-   Configure BuildConfigs
-   Use S2I
-   Manage application lifecycle
-   Configure security
-   Troubleshoot applications
-   Create Tekton pipelines

------------------------------------------------------------------------

Version:

    OpenShift 4.18
    DO288 Alignment
