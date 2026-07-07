# DevOps Wala Vert.x Site

Website: **devops-wala.com**  
Project Name: **DevOps Wala CloudOps Portal**  
Package Name: **com.devopswala.site**  
Main Verticle: **com.devopswala.site.MainVerticle**

This file contains the updated project values in one Markdown document.  
The Red Hat-specific names have been replaced with your own branding, because borrowing names from giant companies is how tiny projects accidentally summon compliance demons.

---

## Updated Project Identity

| Field | Old Value | New Value |
|---|---|---|
| Website | Not defined | `devops-wala.com` |
| Group ID | `com.redhat` | `com.devopswala` |
| Artifact ID | `vertx-site` | `devops-wala-site` |
| Java Package | `com.redhat.vertx_site` | `com.devopswala.site` |
| Main Verticle | `com.redhat.vertx_site.MainVerticle` | `com.devopswala.site.MainVerticle` |
| App Name | Vert.x application | DevOps Wala CloudOps Portal |
| Homepage Text | Welcome to your Vert.x app | Welcome to DevOps Wala CloudOps Portal |

---

## Suggested Folder Structure

```text
devops-wala-site/
├── pom.xml
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/
│   │           └── devopswala/
│   │               └── site/
│   │                   └── MainVerticle.java
│   └── test/
│       └── java/
│           └── com/
│               └── devopswala/
│                   └── tests/
│                       └── DevOpsWalaSiteTest.java
```

---

## Updated `pom.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

  <modelVersion>4.0.0</modelVersion>

  <groupId>com.devopswala</groupId>
  <artifactId>devops-wala-site</artifactId>
  <version>1.0.0-SNAPSHOT</version>

  <name>DevOps Wala CloudOps Portal</name>
  <description>A lightweight Vert.x web application for devops-wala.com</description>
  <url>https://devops-wala.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

    <maven-compiler-plugin.version>3.8.1</maven-compiler-plugin.version>
    <maven-shade-plugin.version>3.2.4</maven-shade-plugin.version>
    <maven-surefire-plugin.version>3.0.0-M5</maven-surefire-plugin.version>
    <exec-maven-plugin.version>3.0.0</exec-maven-plugin.version>

    <vertx.version>4.4.4</vertx.version>
    <junit.version>4.12</junit.version>

    <main.verticle>com.devopswala.site.MainVerticle</main.verticle>
    <launcher.class>io.vertx.core.Launcher</launcher.class>

    <app.website>devops-wala.com</app.website>
    <app.brand>DevOps Wala</app.brand>
    <app.display.name>DevOps Wala CloudOps Portal</app.display.name>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>io.vertx</groupId>
        <artifactId>vertx-stack-depchain</artifactId>
        <version>${vertx.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <dependency>
      <groupId>io.vertx</groupId>
      <artifactId>vertx-core</artifactId>
    </dependency>

    <dependency>
      <groupId>io.vertx</groupId>
      <artifactId>vertx-web</artifactId>
    </dependency>

    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>${junit.version}</version>
      <scope>test</scope>
    </dependency>

    <dependency>
      <groupId>io.vertx</groupId>
      <artifactId>vertx-unit</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>

      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>${maven-compiler-plugin.version}</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
          <verbose>true</verbose>
        </configuration>
      </plugin>

      <plugin>
        <artifactId>maven-shade-plugin</artifactId>
        <version>${maven-shade-plugin.version}</version>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>shade</goal>
            </goals>
            <configuration>
              <transformers>
                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                  <manifestEntries>
                    <Main-Class>${launcher.class}</Main-Class>
                    <Main-Verticle>${main.verticle}</Main-Verticle>
                  </manifestEntries>
                </transformer>
                <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer"/>
              </transformers>
              <outputFile>${project.build.directory}/${project.artifactId}-${project.version}-fat.jar</outputFile>
            </configuration>
          </execution>
        </executions>
      </plugin>

      <plugin>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>${maven-surefire-plugin.version}</version>
      </plugin>

      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>${exec-maven-plugin.version}</version>
        <configuration>
          <mainClass>io.vertx.core.Launcher</mainClass>
          <arguments>
            <argument>run</argument>
            <argument>${main.verticle}</argument>
          </arguments>
        </configuration>
      </plugin>

    </plugins>
  </build>

</project>
```

---

## Updated `MainVerticle.java`

File path:

```text
src/main/java/com/devopswala/site/MainVerticle.java
```

```java
package com.devopswala.site;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;

public class MainVerticle extends AbstractVerticle {

    private static final int PORT = 8080;
    private static final String BRAND_NAME = "DevOps Wala";
    private static final String WEBSITE = "devops-wala.com";
    private static final String APP_NAME = "DevOps Wala CloudOps Portal";

    @Override
    public void start() {
        HttpServer server = vertx.createHttpServer();

        Router router = Router.router(vertx);

        router.get("/").handler(this::handleHomePage);
        router.get("/health").handler(this::handleHealthCheck);

        server.requestHandler(router).listen(PORT, http -> {
            if (http.succeeded()) {
                System.out.println(APP_NAME + " is running at http://localhost:" + PORT);
            } else {
                System.err.println("Failed to start " + APP_NAME);
                http.cause().printStackTrace();
            }
        });
    }

    private void handleHomePage(RoutingContext routingContext) {
        HttpServerResponse response = routingContext.response();

        response.putHeader("Content-Type", "text/html; charset=UTF-8");

        response.end(
            "<!DOCTYPE html>" +
            "<html lang='en'>" +
            "<head>" +
            "  <meta charset='UTF-8'>" +
            "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "  <title>" + APP_NAME + "</title>" +
            "  <style>" +
            "    body {" +
            "      margin: 0;" +
            "      font-family: Arial, sans-serif;" +
            "      background: linear-gradient(135deg, #0f172a, #1e293b, #0ea5e9);" +
            "      color: #ffffff;" +
            "      min-height: 100vh;" +
            "      display: flex;" +
            "      align-items: center;" +
            "      justify-content: center;" +
            "      text-align: center;" +
            "    }" +
            "    .card {" +
            "      max-width: 760px;" +
            "      padding: 48px;" +
            "      border-radius: 24px;" +
            "      background: rgba(15, 23, 42, 0.82);" +
            "      box-shadow: 0 24px 70px rgba(0, 0, 0, 0.35);" +
            "      border: 1px solid rgba(255, 255, 255, 0.14);" +
            "    }" +
            "    h1 {" +
            "      font-size: 42px;" +
            "      margin-bottom: 12px;" +
            "    }" +
            "    p {" +
            "      font-size: 18px;" +
            "      line-height: 1.6;" +
            "      color: #dbeafe;" +
            "    }" +
            "    .badge {" +
            "      display: inline-block;" +
            "      margin-top: 20px;" +
            "      padding: 10px 18px;" +
            "      border-radius: 999px;" +
            "      background: #38bdf8;" +
            "      color: #082f49;" +
            "      font-weight: bold;" +
            "    }" +
            "  </style>" +
            "</head>" +
            "<body>" +
            "  <main class='card'>" +
            "    <h1>Welcome to " + APP_NAME + "</h1>" +
            "    <p>Learn DevOps. Build Cloud. Ship Faster.</p>" +
            "    <p>Your practical hub for containers, Kubernetes, CI/CD, automation, and cloud-native engineering.</p>" +
            "    <div class='badge'>" + WEBSITE + "</div>" +
            "  </main>" +
            "</body>" +
            "</html>"
        );
    }

    private void handleHealthCheck(RoutingContext routingContext) {
        routingContext.response()
            .putHeader("Content-Type", "application/json")
            .end("{\"status\":\"UP\",\"service\":\"DevOps Wala CloudOps Portal\"}");
    }

    public static void main(String[] args) {
        Vertx vertx = Vertx.vertx();
        vertx.deployVerticle(new MainVerticle());
    }
}
```

---

## Updated `DevOpsWalaSiteTest.java`

File path:

```text
src/test/java/com/devopswala/tests/DevOpsWalaSiteTest.java
```

```java
package com.devopswala.tests;

import com.devopswala.site.MainVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpClientResponse;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.unit.TestContext;
import io.vertx.ext.unit.junit.VertxUnitRunner;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(VertxUnitRunner.class)
public class DevOpsWalaSiteTest {

    private Vertx vertx;

    @Before
    public void setUp(TestContext context) {
        vertx = Vertx.vertx();
        vertx.deployVerticle(new MainVerticle(), context.asyncAssertSuccess());
    }

    @After
    public void tearDown(TestContext context) {
        vertx.close(context.asyncAssertSuccess());
    }

    @Test
    public void testHomePage(TestContext context) {
        final HttpClient client = vertx.createHttpClient();

        client.request(HttpMethod.GET, 8080, "localhost", "/")
            .compose(request -> request.send().compose(HttpClientResponse::body))
            .onComplete(context.asyncAssertSuccess(buffer -> {
                context.assertTrue(buffer.toString().contains("Welcome to DevOps Wala CloudOps Portal"));
                context.assertTrue(buffer.toString().contains("devops-wala.com"));
                client.close();
            }));
    }

    @Test
    public void testHealthCheck(TestContext context) {
        final HttpClient client = vertx.createHttpClient();

        client.request(HttpMethod.GET, 8080, "localhost", "/health")
            .compose(request -> request.send().compose(HttpClientResponse::body))
            .onComplete(context.asyncAssertSuccess(buffer -> {
                context.assertTrue(buffer.toString().contains("\"status\":\"UP\""));
                context.assertTrue(buffer.toString().contains("DevOps Wala CloudOps Portal"));
                client.close();
            }));
    }
}
```

---

## Maven Commands

### Run the app

```bash
mvn clean compile exec:java
```

Open:

```text
http://localhost:8080
```

### Test the app

```bash
mvn test
```

### Build fat JAR

```bash
mvn clean package
```

Generated JAR:

```text
target/devops-wala-site-1.0.0-SNAPSHOT-fat.jar
```

### Run fat JAR

```bash
java -jar target/devops-wala-site-1.0.0-SNAPSHOT-fat.jar
```

---

## Useful `curl` Checks

### Homepage

```bash
curl http://localhost:8080/
```

Expected text:

```text
Welcome to DevOps Wala CloudOps Portal
```

### Health Check

```bash
curl http://localhost:8080/health
```

Expected response:

```json
{"status":"UP","service":"DevOps Wala CloudOps Portal"}
```

---

## Suggested Fancy Brand Names

You can use these names inside pages, services, routes, or future modules:

| Purpose | Suggested Name |
|---|---|
| Main app | DevOps Wala CloudOps Portal |
| Learning section | WalaOps Academy |
| CI/CD section | Pipeline Forge |
| Kubernetes section | Kube Wala Labs |
| Automation section | AutoOps Engine |
| Monitoring section | CloudPulse Monitor |
| Deployment section | ShipFast Console |
| Infrastructure section | InfraMantra |
| Blog section | DevOps Dispatch |
| Community section | WalaOps Circle |

---

## Recommended GitHub Repository Name

```text
devops-wala-vertx-site
```

---

## Recommended README Description

```text
A lightweight Eclipse Vert.x web application for devops-wala.com, built as a beginner-friendly cloud-native Java project with routing, health checks, Maven packaging, and a runnable fat JAR.
```

---

## Final Project Summary

```text
Website: devops-wala.com
Application: DevOps Wala CloudOps Portal
Group ID: com.devopswala
Artifact ID: devops-wala-site
Main Package: com.devopswala.site
Test Package: com.devopswala.tests
Main Class: com.devopswala.site.MainVerticle
Port: 8080
Home Route: /
Health Route: /health
```
