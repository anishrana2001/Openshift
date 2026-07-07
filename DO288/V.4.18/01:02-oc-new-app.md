# 🚀 Understanding `oc new-app` Command --- Vert.x Site Deployment

> **Course:** Red Hat OpenShift Developer II (DO288) v4.18\
> **Topic:** Source-to-Image (S2I) Application Deployment\
> **Difficulty:** Intermediate

------------------------------------------------------------------------

# 📌 Command

``` bash
oc new-app --name vertx-site \
--build-env \
MAVEN_MIRROR_URL=http://nexus-infra.apps.ocp4.example.com/java \
--env JAVA_APP_JAR=vertx-site-1.0.0-SNAPSHOT-fat.jar \
-i redhat-openjdk18-openshift:1.8 \
--context-dir apps/builds-applications/vertx-site \
https://git.ocp4.example.com/developer/DO288-apps
```

------------------------------------------------------------------------

# 🎯 Purpose of This Command

This command creates a complete OpenShift application from source code.

OpenShift performs:

    Git Repository
          |
          ↓
    Source Code
          |
          ↓
    S2I Builder Image
          |
          ↓
    Maven Build
          |
          ↓
    Container Image
          |
          ↓
    Deployment
          |
          ↓
    Running Pod

------------------------------------------------------------------------

# 🧩 Command Explanation

## 1. `oc new-app`

``` bash
oc new-app
```

Creates a new application in OpenShift.

Automatically creates:

  Resource      Purpose
  ------------- -------------------------
  BuildConfig   Defines build process
  ImageStream   Tracks container images
  Deployment    Runs application
  Service       Provides networking

------------------------------------------------------------------------

# 2. Application Name

``` bash
--name vertx-site
```

Defines the application name.

Created resources:

    Deployment:
    vertx-site

    Service:
    vertx-site

    BuildConfig:
    vertx-site

------------------------------------------------------------------------

# 3. Build Environment Variable

``` bash
--build-env MAVEN_MIRROR_URL=http://nexus-infra.apps.ocp4.example.com/java
```

Defines variables used during image creation.

This variable configures Maven to use an internal repository.

Normal Maven flow:

    OpenShift Builder
           |
           ↓
    Internet
           |
           ↓
    Maven Central

Enterprise flow:

    OpenShift Builder
           |
           ↓
    Nexus Repository
           |
           ↓
    Maven Dependencies

Benefits:

-   Faster builds
-   Controlled packages
-   No external dependency

------------------------------------------------------------------------

# 4. Runtime Environment Variable

``` bash
--env JAVA_APP_JAR=vertx-site-1.0.0-SNAPSHOT-fat.jar
```

Defines which Java JAR file should start when the container runs.

Equivalent command:

``` bash
java -jar vertx-site-1.0.0-SNAPSHOT-fat.jar
```

------------------------------------------------------------------------

# 5. Builder Image

``` bash
-i redhat-openjdk18-openshift:1.8
```

Specifies the S2I builder image.

Contains:

    OpenJDK
    +
    Maven
    +
    S2I Scripts
    +
    Java Runtime

------------------------------------------------------------------------

# Understanding S2I

S2I means Source-to-Image.

It converts:

    Source Code
          +
    Builder Image
          |
          ↓
    Container Image

OpenShift automatically performs the build process.

------------------------------------------------------------------------

# 6. Context Directory

``` bash
--context-dir apps/builds-applications/vertx-site
```

Specifies which folder inside the Git repository should be built.

Example repository:

    DO288-apps

    ├── apps
    │
    ├── builds-applications
    │       |
    │       ├── vertx-site
    │       ├── another-app
    │
    └── examples

Only this application is built:

    apps/builds-applications/vertx-site

Useful for:

-   Monorepositories
-   Multiple applications in one repository

------------------------------------------------------------------------

# 7. Git Repository URL

``` bash
https://git.ocp4.example.com/developer/DO288-apps
```

Source location of the application.

OpenShift clones the repository and starts the S2I process.

------------------------------------------------------------------------

# 🔄 Complete Execution Flow

## Step 1: Clone Repository

    Git Repository
           |
           ↓
    Download Source Code

------------------------------------------------------------------------

## Step 2: Select Application Directory

    apps/builds-applications/vertx-site

------------------------------------------------------------------------

## Step 3: Start Builder Image

    redhat-openjdk18-openshift:1.8

------------------------------------------------------------------------

## Step 4: Maven Build

Uses:

    MAVEN_MIRROR_URL

to download dependencies.

------------------------------------------------------------------------

## Step 5: Generate Application JAR

Output:

    vertx-site-1.0.0-SNAPSHOT-fat.jar

------------------------------------------------------------------------

## Step 6: Create Container Image

Example:

    vertx-site:latest

------------------------------------------------------------------------

## Step 7: Deploy Application

Creates:

    Deployment
          |
          ↓
    ReplicaSet
          |
          ↓
    Pod
          |
          ↓
    Service

------------------------------------------------------------------------

# 🔍 Verify Deployment

Check resources:

``` bash
oc get all
```

Expected:

    pod/vertx-site-xxxxx

    service/vertx-site

    deployment/vertx-site

    buildconfig/vertx-site

    imagestream/vertx-site

------------------------------------------------------------------------

# 📊 Command Summary

  Option            Purpose
  ----------------- ----------------------
  `oc new-app`      Create application
  `--name`          Application name
  `--build-env`     Build-time variables
  `--env`           Runtime variables
  `-i`              Builder image
  `--context-dir`   Build directory
  Git URL           Source repository

------------------------------------------------------------------------

# 🎓 DO288 Exam Notes

Important concepts:

## `--build-env`

Used during:

    Source → Image Build

Example:

-   Maven settings
-   Build configuration

## `--env`

Used during:

    Container Runtime

Example:

-   Application configuration
-   Java startup options

## S2I

Converts:

    Source Code
          ↓
    Container Image

------------------------------------------------------------------------

# 🧠 Memory Trick

    NAME
     |
     |--name


    BUILD SETTINGS
     |
     |--build-env


    RUN SETTINGS
     |
     |--env


    BUILDER IMAGE
     |
     |-i


    APPLICATION PATH
     |
     |--context-dir


    SOURCE CODE
     |
     |Git URL

------------------------------------------------------------------------

# ✅ Final Understanding

This single command automates:

    Developer Work
           +
    Build Process
           +
    Container Creation
           +
    Deployment

Complete OpenShift workflow:

    Code
     ↓
    Build
     ↓
    Image
     ↓
    Deployment
     ↓
    Pod
     ↓
    Application

**DO288 v4.18 --- OpenShift Developer II**
