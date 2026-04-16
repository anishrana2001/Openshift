# 🚀 Question 7. How to create models ? – End-to-End Lab (EX267 Level)

## How to create lab?
```
lab start -t AI265 serving-saving

oc -n rhoai-multimodel get secret aws-connection-rhoaiserving-using -o json  | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"' > /tmp/S3file

cat /tmp/.s3cfg | awk ' 
/AWS_ACCESS_KEY_ID/   { print $0 }
/AWS_SECRET_ACCESS_KEY/ { print $0 } 
/AWS_DEFAULT_REGION/   { print $0 }
/AWS_S3_ENDPOINT/      { print "AWS_S3_HOST: " $2 "/models-bucket" }'  > /tmp/.s3cfg
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

Your tasks:

✅ Deploy model on **Multi-Model Server**
✅ Enable **External Route + Without Token**
