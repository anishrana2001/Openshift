# Guided Exercise: Customizing an Existing S2I Base Image

## Objective

Customize the `assemble` and `run` scripts of an **Apache HTTP Server**
builder image to override the default built-in S2I scripts with
application-specific logic.

---

## Table of Contents

1. [Outcomes](#outcomes)
2. [Prerequisites](#prerequisites)
3. [Step 1: Prepare the Environment](#step-1-prepare-the-environment)
4. [Step 2: Explore the S2I Scripts in the Builder Image](#step-2-explore-the-s2i-scripts-in-the-builder-image)
5. [Step 3: Review the Application Source Code and Custom S2I Scripts](#step-3-review-the-application-source-code-and-custom-s2i-scripts)
6. [Step 4: Deploy the Application to OpenShift](#step-4-deploy-the-application-to-openshift)
7. [Step 5: Verify the Custom S2I Scripts Execution](#step-5-verify-the-custom-s2i-scripts-execution)
8. [Step 6: Test the Application](#step-6-test-the-application)
9. [Step 7: Inspect Application Logs](#step-7-inspect-application-logs)
10. [Step 8: Finish and Clean Up](#step-8-finish-and-clean-up)
11. [Summary](#summary)

---

## Outcomes

By completing this exercise, you will be able to:

- Customize the `assemble` and `run` S2I scripts of an Apache HTTP
  Server builder image.
- Override the default built-in S2I scripts with application-specific
  scripts placed in the `.s2i/bin/` directory.
- Deploy a customized S2I application to a Red Hat OpenShift cluster.
- Verify that the custom S2I scripts are executed during the build
  and runtime phases.

---

## Prerequisites

- Access to the **workstation** machine as the `student` user.
- Access to the OpenShift cluster at `https://api.ocp4.example.com:6443`.
- Access to the classroom image registry at
  `registry.ocp4.example.com:8443`.
- The `DO288-apps` Git repository is available at
  `https://git.ocp4.example.com/developer/DO288-apps`.

---

## Step 1: Prepare the Environment


> **Note:** The `Deployment` resource is used in this exercise.
> The `DeploymentConfig` resource is deprecated from OpenShift 4.14.
> Some `oc` commands may show the following warning, which can be
> safely ignored:
>
> ```
> Warning: apps.openshift.io/v1 DeploymentConfig is deprecated
> in v4.14+, unavailable in v4.10000+
> ```

---

## Step 2: Explore the S2I Scripts in the Builder Image

### 2.1 Authenticate Podman with the Classroom Image Registry

Log in to the classroom image registry using Podman:

```bash
[student@workstation ~]$ podman login \
  -u developer -p developer \
  registry.ocp4.example.com:8443
```

**Expected Output:**

```
Login Succeeded!
```

---

### 2.1.1 Create a directory on `workstation` VM.
```
mkdir -p /home/student/task1-customizing-existing-S2I-image/
```
### 2.1.2 Download image

```bash
podman pull docker://registry.ocp4.example.com:8443/ubi9/httpd-24
```
### 2.1.3 Identify the location?

```
skopeo inspect  docker://registry.ocp4.example.com:8443/ubi9/httpd-24 | grep io.openshift.s2i
```

Or you can use below command:

```
podman inspect \
  --format='{{ index .Config.Labels "io.openshift.s2i.scripts-url"}}' \
 ubi9/httpd-24
```

**OUTPUT**
```
image:///usr/libexec/s2i
```

### 2.2 Run a Container from the `httpd-24` Builder Image

Use Podman to create a container from the `httpd-24` builder image.
Override the container entry point to run an interactive shell:

```bash
[student@workstation ~]$ podman run --name webserver -it --rm \
  registry.ocp4.example.com:8443/ubi9/httpd-24 bash
```

### 2.3 Inspect the Default S2I Scripts

### 2.3.2 Navigate to the S2I scripts directory **inside the container** and inspect the default scripts:

```bash
bash-5.1$ cd /usr/libexec/s2i
bash-5.1$ cat assemble
```

```bash
bash-5.1$ cat run
```

```bash
bash-5.1$ cat usage
```


> **Why these steps?**
> Inspecting the default S2I scripts helps you understand what the
> builder image does by default, so you can create effective wrapper
> or override scripts.

---

### 2.4 Exit the Container

```bash
bash-5.1$ exit
```

---

## Step 3: Review the Application Source Code and Custom S2I Scripts

### 3.1 Navigate to the Application Directory

Change to the directory containing the application source code:

```bash
[student@workstation ~]$ cd /home/student/task1-customizing-existing-S2I-image/
```

---

### 3.2 Create a new file `index.html`



```bash
[student@workstation s2i-scripts]$ echo "Hello Class! DO288 rocks!!!" > /home/student/task1-customizing-existing-S2I-image/index.html
```

---

### 3.3 Inspect the Custom `assemble` Script

The custom S2I scripts are located in the `.s2i/bin/` directory.
Inspect the custom `assemble` script:

```bash
[student@workstation s2i-scripts]$ cat .s2i/bin/assemble
```

**Key Customization Section:**

```bash
######## CUSTOMIZATION STARTS HERE ############

echo "---> Installing application source"
cp -Rf /tmp/src/*.html ./

DATE=`date "+%b %d, %Y @ %H:%M %p"`

echo "---> Creating info page"
echo "Page built on $DATE" >> ./info.html
echo "Proudly served by Apache HTTP Server version $HTTPD_VERSION" \
  >> ./info.html

######## CUSTOMIZATION ENDS HERE ############
```

> **What this script does:**
> - Copies the `index.html` file from the application source to the
>   web server document root at `/opt/app-root/src`.
> - Creates an `info.html` file containing:
>   - The **page build timestamp**
>   - The **Apache HTTP Server version** from the environment variable
>     `$HTTPD_VERSION`

---

### 3.4 Inspect the Custom `run` Script

Inspect the custom `run` script:

```bash
[student@workstation s2i-scripts]$ cat .s2i/bin/run
```

**Key Customization Section:**

```bash
# Make Apache show 'debug' level logs during startup
exec run-httpd -e debug $@
```

> **What this script does:**
> - Changes the default Apache HTTP Server **log level** to `debug`
>   during startup, providing more detailed log output for
>   troubleshooting.
>
> **Important:** The `exec` command ensures the `run-httpd` process
> runs with **PID 1**, enabling proper signal propagation during
> container shutdown.

---

## Step 4: Deploy the Application to OpenShift

### 4.1 Log in to OpenShift

Authenticate to the OpenShift cluster as the `developer` user:

```bash
[student@workstation s2i-scripts]$ oc login -u developer -p developer \
  https://api.ocp4.example.com:6443
```

**Expected Output:**

```
Login successful.
...output omitted...
```

---

### 4.2 Switch to the `builds-s2i` Project

Ensure you are working in the correct OpenShift project:

```bash
[student@workstation s2i-scripts]$ oc project builds-s2i
```

**Expected Output:**

```
...output omitted...
```

---

### 4.3 Verify the Image Stream Tag

Confirm that the image stream tag `httpd:2.4-ubi9` points to the
correct image in the classroom registry:

```bash
oc -n openshift get is/httpd
```
### Or you can execute this command.
```
[student@workstation s2i-scripts]$ oc -n openshift get is/httpd -o \
  jsonpath='{.spec.tags[?(@.name == "2.4-ubi9")].from}' | jq
```

**Expected Output:**

```json
{
  "kind": "DockerImage",
  "name": "registry.ocp4.example.com:8443/ubi9/httpd-24:latest"
}
```

> **Note:** The `-o jsonpath` option is used to extract specific
> fields from the JSON representation of a resource.
> For more information, refer to the
> [Kubernetes JSONPath documentation](https://kubernetes.io/docs/reference/kubectl/jsonpath/).

---

### 4.4 Create the Application

Create an application named **`hello-web`** from the provided source
code. Use the tilde (`~`) notation to prefix the Git URL with the
`httpd:2.4-ubi9` image stream, ensuring the application uses the
`ubi9/httpd-24` builder image:

```bash
[student@workstation s2i-scripts]$ oc new-app --name hello-web \
  --context-dir labs/builds-s2i/s2i-scripts \
  httpd:2.4-ubi9~https://git.ocp4.example.com/developer/DO288-apps
```

**Expected Output:**

```
...output omitted...
--> Creating resources ...
    imagestream.image.openshift.io "hello-web" created
    buildconfig.build.openshift.io "hello-web" created
    deployment.apps "hello-web" created
    service "hello-web" created
--> Success
...output omitted...
```

> **Note:** The `~` (tilde) notation instructs OpenShift to use the
> specified image stream as the S2I builder for the provided Git
> repository.

---

### 4.5 Monitor the Build

Wait until the build finishes and the application container image
is pushed to the OpenShift internal registry:

```bash
[student@workstation s2i-scripts]$ oc get build
```

**Expected Output:**

```
NAME          ...  STATUS     ...
hello-web-1   ...  Complete   ...
```

---

## Step 5: Verify the Custom S2I Scripts Execution

View the build logs to confirm that the custom S2I scripts were
executed during the build process:

```bash
[student@workstation s2i-scripts]$ oc logs -f bc/hello-web
```

**Expected Output:**

```
...output omitted...
Cloning "https://git.ocp4.example.com/developer/DO288-apps" ...
...output omitted...
STEP 9/10: RUN /tmp/scripts/assemble
---> Enabling s2i support in httpd24 image
    AllowOverride All
---> Installing application source
---> Creating info page
STEP 10/10: CMD /tmp/scripts/run
COMMIT temp.builder.openshift.io/builds-s2i/hello-web-1:986469c8
...output omitted...
Push successful
```

> **Observation:** The log output confirms that:
> - The **custom `assemble` script** installed the application source
>   and created the `info.html` page.
> - The **custom `run` script** was set as the container startup
>   command.
> - The custom scripts **overrode** the default built-in S2I scripts
>   from the builder image.

---

## Step 6: Test the Application

### 6.1 Verify the Application Pod Status

Wait until the application is deployed, then check the pod status.
The application pod should be in the **Running** state:

```bash
[student@workstation s2i-scripts]$ oc get po
```

**Expected Output:**

```
NAME                         READY   STATUS      RESTARTS   AGE
hello-web-1-build            0/1     Completed   0          105s
hello-web-7bc86dd97-wjvhx    1/1     Running     0          72s
```

---

### 6.2 Expose the Application via a Route

Create a route to expose the application for external access:

```bash
[student@workstation s2i-scripts]$ oc expose svc hello-web
```

**Expected Output:**

```
route.route.openshift.io/hello-web exposed
```

---

### 6.3 Retrieve the Route URL

Obtain the external route URL:

```bash
[student@workstation s2i-scripts]$ oc get route
```

**Expected Output:**

```
NAME        HOST/PORT                                    ...
hello-web   hello-web-builds-s2i.apps.ocp4.example.com  ...
```

---

### 6.4 Test the Index Page

Retrieve the main index page of the application:

```bash
[student@workstation s2i-scripts]$ curl \
  http://hello-web-builds-s2i.apps.ocp4.example.com
```

**Expected Output:**

```
Hello Class! DO288 rocks!!!
```

---

### 6.5 Test the Info Page

Retrieve the dynamically generated `info.html` page:

```bash
[student@workstation s2i-scripts]$ curl \
  http://hello-web-builds-s2i.apps.ocp4.example.com/info.html
```

**Expected Output:**

```
Page built on ...
Proudly served by Apache HTTP Server version 2.4
```

> **Observation:** The `info.html` page was dynamically created by
> the custom `assemble` script during the build process, confirming
> that the customization was applied successfully.

---

## Step 7: Inspect Application Logs

Inspect the logs for the **`hello-web`** deployment. Since the
custom `run` script changed the startup log level to `debug`, you
should see detailed debug-level log messages:

```bash
[student@workstation s2i-scripts]$ oc logs deploy/hello-web
```

**Expected Output:**

```
...output omitted...
10.8.0.2 - - [16/Oct/2023:20:38:50 +0000] \
  "GET / HTTP/1.1" 200 28 "-" "curl/7.61.1"
10.8.0.2 - - [16/Oct/2023:20:40:25 +0000] \
  "GET /info.html HTTP/1.1" 200 87 "-" "curl/7.61.1"
```

> **Observation:** The `debug` log level set in the custom `run`
> script is reflected in the application pod logs, confirming that
> the custom `run` script was executed at container startup.

---

## Step 8: Finish and Clean Up

On the **workstation** machine, use the `lab` command to complete
this exercise and clean up all resources. This step is important
to ensure that resources from this exercise do not impact
upcoming exercises:

```bash
[student@workstation ~]$ lab finish builds-s2i
```

---

## Summary

| Step | Action                                      | Result                                      |
|------|---------------------------------------------|---------------------------------------------|
| 1    | Prepared the exercise environment           | System ready for the exercise               |
| 2    | Explored default S2I scripts in the image   | Located scripts at `/usr/libexec/s2i`       |
| 3    | Reviewed custom S2I scripts in `.s2i/bin/`  | Understood customization logic              |
| 4    | Deployed `hello-web` app to OpenShift       | App built and deployed successfully         |
| 5    | Verified custom script execution            | Custom scripts overrode built-in scripts    |
| 6    | Tested the application via HTTP             | Index and info pages returned correctly     |
| 7    | Inspected application logs                  | Debug-level logs confirmed custom `run`     |
| 8    | Cleaned up exercise resources               | Environment ready for next exercise         |

---

### Key Takeaways

- Custom S2I scripts placed in the **`.s2i/bin/`** directory of the
  application repository **override** the default built-in scripts
  in the builder image.
- The custom **`assemble`** script can perform pre- and post-build
  actions such as copying files and generating dynamic content.
- The custom **`run`** script must use **`exec`** to invoke the
  server process with **PID 1** for proper signal handling.
- The **`oc logs -f bc/<buildconfig-name>`** command is useful for
  monitoring build progress and verifying script execution.
- The **`oc logs deploy/<deployment-name>`** command helps verify
  runtime behavior, such as confirming the log level set by the
  custom `run` script.

---

*End of Exercise*
