## Prepare the lab.
```
lab start -t AI262 projects-data
```
Qeustion: Create a data connection in Red Hat OpenShift AI (RHOAI) that stores information to connect to an S3 bucket.

- Use the following values to fill out and submit the form.

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| Name        | projects-data-connection                           |
| Access key  |  minio                                             |
| Secret key  | minio123                                           |
| Endpoint    | https://minio-api-minio.apps.ocp4.example.com      |
| Region      | us-east-1                                          |
| Bucket      | projects-data-bucket                               |


- Attach a data connection to a workbench `projects-data-wb` in RHOAI under `projects-data` project and use `Standard Data Science` as a image.
- Use the data connection values to upload and download objects to the S3 bucket within a Python Jupyter notebook.

