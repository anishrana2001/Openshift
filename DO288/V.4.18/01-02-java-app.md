# Java Application Development with S2I Incremental Builds

---

## Table of Contents

1. [Overview](#overview)
2. [Actors](#actors)
3. [Preconditions](#preconditions)
4. [Step 1: Pull the Builder Image](#step-1-pull-the-builder-image)
5. [Step 2: Inspect the S2I Scripts Location](#step-2-inspect-the-s2i-scripts-location)
6. [Step 3: Initial Build — Application with Dependencies](#step-3-initial-build--application-with-dependencies)
7. [Step 4: Create a Wrapper for the Assemble Script](#step-4-create-a-wrapper-for-the-assemble-script)
8. [Step 5: Create a Wrapper for the Run Script](#step-5-create-a-wrapper-for-the-run-script)
9. [Step 6: Create the Save-Artifacts Script](#step-6-create-the-save-artifacts-script)
10. [Step 7: Code Update — Same Dependencies](#step-7-code-update--same-dependencies)
11. [Step 8: Code Update — Adding a New Dependency](#step-8-code-update--adding-a-new-dependency)
12. [Summary Table](#summary-table)
13. [Key Takeaways](#key-takeaways)

---

## Overview

A developer builds a **Java application** on OpenShift using the
**Source-to-Image (S2I)** build strategy. The application relies on
external dependencies managed by **Maven**. Over time, the developer:

- Updates the source code while keeping the **same dependencies**
- Updates the source code and **adds a new dependency**

Apache Maven is the industry-standard build automation and project management tool for Java. 
It uses a declarative XML file called pom.xml (Project Object Model) to automatically 
download libraries (dependencies), compile source code, run tests, 
and package your application into executable .jar or .war files.

S2I **Incremental Builds** are used to reduce build time by caching
previously downloaded dependencies, avoiding redundant downloads in
every build cycle.

---

## Actors

| Actor         | Description                                        |
|---------------|----------------------------------------------------|
| Developer     | Writes and updates the Java application code       |
| OpenShift     | Hosts and manages the S2I build pipeline           |
| S2I Builder   | Executes assemble, run, and save-artifacts scripts |
| Maven         | Manages Java application dependencies              |
| Container Registry | Stores the Java S2I builder image             |

---

## Preconditions

- A Java S2I builder image is available in the container registry.
- The developer has access to OpenShift and the container registry.
- `podman` and `skopeo` CLI tools are installed on the local system.
- Maven is used as the dependency management tool.
- The project follows a standard Maven directory structure.

---

## Step 1: Pull the Builder Image

The developer pulls the Java S2I builder image from the remote
container registry to the local system using the `podman pull` command.

```bash
podman pull \
  myregistry.example.com/rhscl/java-11-rhel7
```

**Expected Output:**

```
...output omitted...
Digest: sha256:...
```

> **Why this step?**
> Pulling the image locally allows the developer to inspect it and
> understand the default S2I scripts location before customizing
> the build process.

---

## Step 2: Inspect the S2I Scripts Location

### Option A: Using `podman inspect`

After pulling the image, the developer uses `podman inspect` to
retrieve the value of the `io.openshift.s2i.scripts-url` label.
This label indicates the **default location** of the S2I scripts
inside the image.

```bash
podman inspect \
  --format='{{ index .Config.Labels "io.openshift.s2i.scripts-url"}}' \
  rhscl/java-11-rhel7
```

**Expected Output:**

```
image:///usr/libexec/s2i
```

---

### Option B: Using `skopeo inspect`

Alternatively, the developer can retrieve the same information
**directly from the remote registry** without pulling the image first:

```bash
skopeo inspect \
  docker://myregistry.example.com/rhscl/java-11-rhel7 \
  | grep io.openshift.s2i.scripts-url
```

**Expected Output:**

```
"io.openshift.s2i.scripts-url": "image:///usr/libexec/s2i",
```

> **Why this step?**
> Knowing the default S2I scripts location (`/usr/libexec/s2i`) is
> essential for creating wrapper scripts that correctly invoke the
> default `assemble` and `run` scripts.

---

## Step 3: Initial Build — Application with Dependencies

The Java application uses **Maven** for dependency management.
The initial `pom.xml` declares the following dependencies:

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>java-s2i-app</artifactId>
  <version>1.0.0</version>

  <dependencies>

    <!-- Dependency 1: Spring Boot Web -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <version>2.7.0</version>
    </dependency>

    <!-- Dependency 2: Hibernate Core -->
    <dependency>
      <groupId>org.hibernate</groupId>
      <artifactId>hibernate-core</artifactId>
      <version>5.6.0.Final</version>
    </dependency>

  </dependencies>
</project>
```

**Initial Build Flow:**

```
Developer pushes source code
          |
          v
  S2I triggers the assemble script
          |
          v
  Maven downloads all dependencies
  (Spring Boot + Hibernate)
          |
          v
  Application is compiled and packaged
          |
          v
  save-artifacts caches the .m2 folder
          |
          v
  Application is deployed on OpenShift
```

> **Note:** During the first build, **all dependencies are downloaded**
> from the Maven repository. This may take considerable time depending
> on the number and size of the dependencies.

---

## Step 4: Create a Wrapper for the `assemble` Script

The developer creates a **custom wrapper** for the `assemble` script
inside the `.s2i/bin/` directory of the project.

**File Path:** `.s2i/bin/assemble`

```bash
#!/bin/bash

echo "Making pre-invocation changes..."

# Restore cached artifacts if available (Incremental Build)
if [ -d /tmp/artifacts ]; then
    echo "Restoring cached Maven dependencies from previous build..."
    mv /tmp/artifacts/.m2 ~/
fi

# Invoke the default S2I assemble script
/usr/libexec/s2i/assemble
rc=$?

if [ $rc -eq 0 ]; then
    echo "Making post-invocation changes..."
    echo "Assemble completed successfully."
else
    echo "Error: assemble script failed with exit code $rc"
fi

exit $rc
```

> **Why this step?**
> The wrapper allows the developer to:
> - **Restore cached artifacts** before the build (enabling incremental builds)
> - **Execute pre- and post-build logic** around the default assemble script
> - **Handle errors** gracefully by checking the exit code

---

## Step 5: Create a Wrapper for the `run` Script

The developer creates a **custom wrapper** for the `run` script
inside the `.s2i/bin/` directory.

**File Path:** `.s2i/bin/run`

```bash
#!/bin/bash

echo "Before calling run..."

# Invoke the default S2I run script using exec
exec /usr/libexec/s2i/run
```

> **Important:** The `exec` command **must** be used when invoking
> the default `run` script. This ensures that:
> - The `run` script executes with **Process ID (PID) 1**
> - **Signal propagation** works correctly during container shutdown
> - The application shuts down gracefully without errors
>
> **Warning:** Do not add any commands after `exec /usr/libexec/s2i/run`
> in the wrapper script, as they will never be executed.

---

## Step 6: Create the `save-artifacts` Script

To enable **Incremental Builds**, the developer creates the
`save-artifacts` script inside the `.s2i/bin/` directory.

**File Path:** `.s2i/bin/save-artifacts`

```bash
#!/bin/bash

echo "Saving Maven dependencies for future builds..."

# Stream the .m2 directory as a tar archive to standard output
tar cf - ~/.m2
```

> **Why this step?**
> The `save-artifacts` script is responsible for:
> - **Streaming cached dependencies** (Maven `.m2` folder) to a tar
>   file via **standard output**
> - Making these artifacts available for **restoration** in the next
>   build via the `assemble` script
> - Significantly **reducing build time** in subsequent builds by
>   avoiding redundant dependency downloads

**S2I Lifecycle with Incremental Builds:**

```
Build N completes
      |
      v
save-artifacts streams .m2 cache to tar
      |
      v
Cache is stored by S2I
      |
      v
Build N+1 starts
      |
      v
assemble restores .m2 cache from /tmp/artifacts
      |
      v
Maven skips already-cached dependencies
      |
      v
Build completes faster
```

---

## Step 7: Code Update — Same Dependencies

The developer updates the **Java source code** — for example, adding
a new REST API endpoint — **without modifying the dependencies**
in `pom.xml`.

### Updated Java Source Code Example

**File:** `src/main/java/com/example/HelloController.java`

```java
package com.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    // Existing endpoint
    @GetMapping("/hello")
    public String hello() {
        return "Hello, World!";
    }

    // Newly added endpoint
    @GetMapping("/status")
    public String status() {
        return "Application is running successfully!";
    }
}
```

### `pom.xml` — No Changes

```xml
<dependencies>

  <!-- Dependency 1: Spring Boot Web (unchanged) -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.7.0</version>
  </dependency>

  <!-- Dependency 2: Hibernate Core (unchanged) -->
  <dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.6.0.Final</version>
  </dependency>

</dependencies>
```

### Incremental Build Flow (Same Dependencies)

```
Developer pushes updated source code
          |
          v
  S2I triggers the assemble script
          |
          v
  assemble restores .m2 cache
  from /tmp/artifacts
          |
          v
  Maven finds all dependencies in cache
  (No downloads needed)
          |
          v
  Application is compiled and packaged
          |
          v
  save-artifacts saves the same .m2 cache
          |
          v
  Application is deployed on OpenShift
```

> **Result:** Build time is **significantly reduced** because Maven
> dependencies are fully restored from the cache and no downloads
> are required.

---

## Step 8: Code Update — Adding a New Dependency

The developer updates both the **Java source code** and the `pom.xml`
to include a **new dependency**: **Lombok**, a library that reduces
boilerplate code in Java.

### Updated `pom.xml` — New Dependency Added

```xml
<dependencies>

  <!-- Existing Dependency 1: Spring Boot Web -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.7.0</version>
  </dependency>

  <!-- Existing Dependency 2: Hibernate Core -->
  <dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.6.0.Final</version>
  </dependency>

  <!-- NEW Dependency 3: Lombok -->
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.24</version>
  </dependency>

</dependencies>
```

### Updated Java Source Code Using Lombok

**File:** `src/main/java/com/example/User.java`

```java
package com.example;

import lombok.Data;

@Data
public class User {
    private String name;
    private String email;
    private int age;
}
```

### Incremental Build Flow (New Dependency Added)

```
Developer pushes updated source code + pom.xml
          |
          v
  S2I triggers the assemble script
          |
          v
  assemble restores .m2 cache
  from /tmp/artifacts
  (Spring Boot + Hibernate are cached)
          |
          v
  Maven detects new dependency (Lombok)
  Downloads ONLY Lombok from repository
          |
          v
  Application is compiled and packaged
          |
          v
  save-artifacts saves updated .m2 cache
  (Spring Boot + Hibernate + Lombok)
          |
          v
  Application is deployed on OpenShift
```

> **Result:** Only the **new dependency (Lombok)** is downloaded.
> Existing dependencies are restored from the cache, keeping
> build time **moderate** compared to a full build.

---

## Summary Table

| Build Scenario                  | Dependencies Downloaded          | Cache Used | Build Time  |
|---------------------------------|----------------------------------|------------|-------------|
| **First Build**                 | All (Spring Boot + Hibernate)    | No         | Slow        |
| **Code Update (Same Deps)**     | None                             | Yes        | Fast        |
| **Code Update (New Dep Added)** | Only new dependency (Lombok)     | Partial    | Moderate    |

---

## Key Takeaways

- **S2I Incremental Builds** significantly reduce build time in
  **CI/CD pipelines** by caching and restoring dependencies between
  builds.

- The **`save-artifacts`** script streams cached dependencies
  (e.g., Maven `.m2` folder) to a tar file via **standard output**
  after each successful build.

- The **`assemble`** script restores cached artifacts from
  `/tmp/artifacts` before building, avoiding redundant downloads.

- When wrapping the **`run`** script, always use **`exec`** to
  maintain **PID 1** for proper signal handling and graceful shutdown.

- Use **`podman inspect`** or **`skopeo inspect`** to locate the
  default S2I scripts path (`/usr/libexec/s2i`) in the builder image.

- Custom S2I scripts must be placed in the **`.s2i/bin/`** directory
  of the project repository.

- Adding a **new dependency** only requires downloading that specific
  dependency, as all previously cached dependencies are restored
  from the incremental build cache.

---

*End of Document*
