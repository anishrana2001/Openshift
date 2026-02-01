

# Question: You need to give ReadOnly access of your OpenShift Container Platform (OCP) cluster to user so that user can monitor all the resources.
For this, you need to create a client certificate that allows the user to examine everything in the cluster but does not allow the user to make any changes.
 
- A client certificate must exists with the username: `mon-punit`
- A group name: `cluster-monitoring-app`
- Members of this group have access to the cluster role: `cluster-reader`
- The client certificate you can download from below link.
- The client certificate must not be able to create or delete projects
- The client certificate must be able to view all pods in the cluster

---
## Solution:

```
[student@workstation ~]$ oc adm groups new cluster-monitoring-app
group.user.openshift.io/cluster-monitoring-app created

[student@workstation ~]$ oc adm groups add-users cluster-monitoring-app  mon-punit
group.user.openshift.io/cluster-monitoring-app added: "mon-punit"


[student@workstation ~]$ oc get clusterrole cluster-reader
NAME             CREATED AT
cluster-reader   2024-03-05T20:06:28Z


[student@workstation ~]$ oc adm policy add-cluster-role-to-group cluster-reader cluster-monitoring-app
clusterrole.rbac.authorization.k8s.io/cluster-reader added: "cluster-monitoring-app"

[student@workstation ~]$ mkdir test
[student@workstation ~]$ cd test/


[student@workstation test]$ openssl req -newkey rsa:4096 -keyout monitoing.key -nodes -subj "/O=cluster-monitoring-app/CN=mon-punit"  -out mon.csr
....+......+...+.....+..........+.....+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.+..+...+....+........+.+.....+..........+..+...+.......+..............+.+............+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*....+.........+....+.....+.+...........+.............+.....+.......+...+..+....+......+.........+..+...+....+..+...+...+.........+.........+......+....+..+.........+...+......................+.....+...+.+.....+.......+........+......+...+................+...............+.........+...........+....+...............+......+......+....................+.+.....+.......+........+............+.+.........+...........+.......+.....+...+.+...+............+.........+..+....+...............+.........+..............+..............................+.......+......+.........+.....+......+...+...............+......+.+........+....+.....+..........+............+...............+........+.+...........+...+..........+........+....+.........+..+.......+...+.....+....+...+..+..................+...+....+.....+.........+.......+..+.+......+......+........+.+...+...............+..+.+..................+......+.........+...........+....+...........+...+...+....+...+........+....+.........+.....+.........+.......+...+......+.....+.........+.+..+...+......+.........+.+.....+...+.+....................+.+...+..................+..+.+..+.............+.....+....+........+.......+..+..........+.....+.........+....+...+.........+..................+..+.+.....+.......+..+....+.....+....+.....+..........+...........................+...+........+...+.+...+...........+......+...+.+.................+..................+.+.....+...+.............+...+......+...+........+...+...................+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
....+......+.+............+..+...+...+....+.....+....+..............+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*................+.+...+......+.....+.+......+........+......+...+...+..........+...............+..+.+..+....+...+........+....+........+.+..+.......+...+...+......+.....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.........................+..+.............+.....+.........+.+............+...............+...+.....+.......+.....+....+...+.....+...+....+..............+......+.+..............+.+.....+....+...+...+.....+...+......+......+.......+............+...+..................+..+.+......+...+...+..+.+............+.........+...+.....+......+......+.............+.....+.+.........+........+...+.+......+........+.+........................+.........+...+.....+...+..........+..............+.......+........+...+.......+.....+......+....+..+.........+.+.........+......+...+............+.........+............+..+.......+.....+....+.....+............+.......+......+...........+....+.....+......+.............+...........+.........+.+......+..................+............+......+..+.......+........+...+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
[student@workstation test]$ 

[student@workstation test]$ cat mon-csr 
-----BEGIN CERTIFICATE REQUEST-----
MIIEejCCAmICAQAwNTEfMB0GA1UECgwWY2x1c3Rlci1tb25pdG9yaW5nLWFwcDES
MBAGA1UEAwwJbW9uLXB1bml0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
AgEAqZfIKcpJjlF3QKjuFrBp8RwGpPLP4BoPm0eDiQsGvl1HrVhR6Hd9+JBeWbua
5rbvv16kk0l/rBa6LxZqO7Yf/9eQCGk1JZDtJI8Ag93B0/G8Ps3c4g4CKPZnQ5Aa
fpowvZPPe1cXTyM1Fn0cT0tnbAuLXCTGCujVU3pMX4OzaYTpuuVxMYZpGV/4k2Q1
b3aQoKZqDWwHWFuY+FETPuniESsRM6HCKdxWt+V5rO89BBygeFv3SEs5VZp4PlJE
CDGLzmbFkGaSppqgQ3jfYhZFIAxU6KASRf5aVNcHQlYLDDDkB8682ffkDWAWfQIo
6a9UU+6vk9XMhTubggHsRPqpWP5j79cA2ij+gzQ03zgAdIgxy6tQpGFag6+L6l68
y9Az39eO41qJo3s91Z5M5o9b3mYFKx0KCZQPf+uoLRXTPXewdOwEXbEvX8c+Zmkx
Ra+7nzO/l4VFrBuUpjvRAQ1u+foOkBwtxvp/lsNfHRVHeZYbvkbHfrHrlsf9ZErC
wpOEddx+T/PrP9K4wyC2WydTevhjgGYvDR29y3Eba6+ATr/Pw49szt6SUPZ/oQmn
Tf+kA1Jd6m9vyUmzK5E62d7h5hBHfxcbRaJhUZvTJsuwFv7Znc+ETYrrdKVkon91
TUcrRVcoaCX5yoOgxZ9ozpvY+btetO+kJjcez1g/x4ziFTcCAwEAAaAAMA0GCSqG
SIb3DQEBCwUAA4ICAQA68HtksMEVrrUw2BmtfLCM1wIInmX7toEBqZ6Cg8P6Neh+
/Hdm+PJrIt3u92ttxDVXz/+NQCc2j9EcJVJQMlYNlr5ZRlCQyTdyD0C1K/QNz98d
3X9NF/fPymq7gKmiDtzqfcv1YskdPE6IyVt1tUmZQDIr70jNuKUccYURuEbyVCMm
zRs4Q+aRfygI+wS2nLzUHorr/1qpTwcAr80bZ7UVu1scNl45VYMMq9125yO+o1AM
QHsR+k2s/jqX+7XA5p1sWAGtZ32znD6LvtlKn6ecUwXPlrfRwGCURQN3Ma7tmvri
xQGnRw5tHfpKGpT7TTEpUiWKThrtWXtZhDOlksXfIzQ2skVm4DaKfpj4irHGA9el
4/bS6IUStWnktFkKx4vP65RK7D9E4m1eOIP8iUPAq5h4cIZ9wQMLr9eaLgDlp2z6
y6LsVyf3xKs08yuADcNPZ0Vrnux67GqMIBnI9EkH1MnRV9o1WrEM2Gw5WAJrFG+T
gbB1qkAG/TO8H4QBN6M5G27vj6/gbYqskQanC3XEGTCVmN4EKMF+4uVEGB2KLBrr
ppKPaYkQlAG9/ohB5zKvg8vrksEh/abvRy575J5oeyr5hs8/+Df1u4UsR5LSXWKp
ROoQV+Q7FAi/hvGdlufghZ+bcfLKJjmmhjZnOkd0b0QbEP/wSu4IWLUMwsjmwA==
-----END CERTIFICATE REQUEST-----


[student@workstation test]$ base64 -w0 mon-csr ; echo 
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJRWVqQ0NBbUlDQVFBd05URWZNQjBHQTFVRUNnd1dZMngxYzNSbGNpMXRiMjVwZEc5eWFXNW5MV0Z3Y0RFUwpNQkFHQTFVRUF3d0piVzl1TFhCMWJtbDBNSUlDSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQWc4QU1JSUNDZ0tDCkFnRUFxWmZJS2NwSmpsRjNRS2p1RnJCcDhSd0dwUExQNEJvUG0wZURpUXNHdmwxSHJWaFI2SGQ5K0pCZVdidWEKNXJidnYxNmtrMGwvckJhNkx4WnFPN1lmLzllUUNHazFKWkR0Skk4QWc5M0IwL0c4UHMzYzRnNENLUFpuUTVBYQpmcG93dlpQUGUxY1hUeU0xRm4wY1QwdG5iQXVMWENUR0N1alZVM3BNWDRPemFZVHB1dVZ4TVlacEdWLzRrMlExCmIzYVFvS1pxRFd3SFdGdVkrRkVUUHVuaUVTc1JNNkhDS2R4V3QrVjVyTzg5QkJ5Z2VGdjNTRXM1VlpwNFBsSkUKQ0RHTHptYkZrR2FTcHBxZ1EzamZZaFpGSUF4VTZLQVNSZjVhVk5jSFFsWUxERERrQjg2ODJmZmtEV0FXZlFJbwo2YTlVVSs2dms5WE1oVHViZ2dIc1JQcXBXUDVqNzljQTJpaitnelEwM3pnQWRJZ3h5NnRRcEdGYWc2K0w2bDY4Cnk5QXozOWVPNDFxSm8zczkxWjVNNW85YjNtWUZLeDBLQ1pRUGYrdW9MUlhUUFhld2RPd0VYYkV2WDhjK1pta3gKUmErN256Ty9sNFZGckJ1VXBqdlJBUTF1K2ZvT2tCd3R4dnAvbHNOZkhSVkhlWllidmtiSGZySHJsc2Y5WkVyQwp3cE9FZGR4K1QvUHJQOUs0d3lDMld5ZFRldmhqZ0dZdkRSMjl5M0ViYTYrQVRyL1B3NDlzenQ2U1VQWi9vUW1uClRmK2tBMUpkNm05dnlVbXpLNUU2MmQ3aDVoQkhmeGNiUmFKaFVadlRKc3V3RnY3Wm5jK0VUWXJyZEtWa29uOTEKVFVjclJWY29hQ1g1eW9PZ3haOW96cHZZK2J0ZXRPK2tKamNlejFnL3g0emlGVGNDQXdFQUFhQUFNQTBHQ1NxRwpTSWIzRFFFQkN3VUFBNElDQVFBNjhIdGtzTUVWcnJVdzJCbXRmTENNMXdJSW5tWDd0b0VCcVo2Q2c4UDZOZWgrCi9IZG0rUEpySXQzdTkydHR4RFZYei8rTlFDYzJqOUVjSlZKUU1sWU5scjVaUmxDUXlUZHlEMEMxSy9RTno5OGQKM1g5TkYvZlB5bXE3Z0ttaUR0enFmY3YxWXNrZFBFNkl5VnQxdFVtWlFESXI3MGpOdUtVY2NZVVJ1RWJ5VkNNbQp6UnM0USthUmZ5Z0krd1Mybkx6VUhvcnIvMXFwVHdjQXI4MGJaN1VWdTFzY05sNDVWWU1NcTkxMjV5TytvMUFNClFIc1IrazJzL2pxWCs3WEE1cDFzV0FHdFozMnpuRDZMdnRsS242ZWNVd1hQbHJmUndHQ1VSUU4zTWE3dG12cmkKeFFHblJ3NXRIZnBLR3BUN1RURXBVaVdLVGhydFdYdFpoRE9sa3NYZkl6UTJza1ZtNERhS2ZwajRpckhHQTllbAo0L2JTNklVU3RXbmt0RmtLeDR2UDY1Uks3RDlFNG0xZU9JUDhpVVBBcTVoNGNJWjl3UU1McjllYUxnRGxwMno2Cnk2THNWeWYzeEtzMDh5dUFEY05QWjBWcm51eDY3R3FNSUJuSTlFa0gxTW5SVjlvMVdyRU0yR3c1V0FKckZHK1QKZ2JCMXFrQUcvVE84SDRRQk42TTVHMjd2ajYvZ2JZcXNrUWFuQzNYRUdUQ1ZtTjRFS01GKzR1VkVHQjJLTEJycgpwcEtQYVlrUWxBRzkvb2hCNXpLdmc4dnJrc0VoL2FidlJ5NTc1SjVvZXlyNWhzOC8rRGYxdTRVc1I1TFNYV0twClJPb1FWK1E3RkFpL2h2R2RsdWZnaForYmNmTEtKam1taGpabk9rZDBiMFFiRVAvd1N1NElXTFVNd3NqbXdBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
[student@workstation test]$ 


## For the reference purpose, you can download this file. But you have to remember all the content. 
[student@workstation test]$ curl -o dummy-csr.yaml https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/EX380-4.14/dummy-csr-0303-token.yaml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   222  100   222    0     0    369      0 --:--:-- --:--:-- --:--:--   370


[student@workstation test]$ cat dummy-csr.yaml 
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: @
spec:
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 604800  # one week
  request: @
  usages:
  - client auth
[student@workstation test]$


[student@workstation test]$ vi dummy-csr.yaml 
[student@workstation test]$ cat dummy-csr.yaml 
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: mon-cert-csr   ### Line modified
spec:
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 604800  # one week
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJRWVqQ0NBbUlDQVFBd05URWZNQjBHQTFVRUNnd1dZMngxYzNSbGNpMXRiMjVwZEc5eWFXNW5MV0Z3Y0RFUwpNQkFHQTFVRUF3d0piVzl1TFhCMWJtbDBNSUlDSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQWc4QU1JSUNDZ0tDCkFnRUFxWmZJS2NwSmpsRjNRS2p1RnJCcDhSd0dwUExQNEJvUG0wZURpUXNHdmwxSHJWaFI2SGQ5K0pCZVdidWEKNXJidnYxNmtrMGwvckJhNkx4WnFPN1lmLzllUUNHazFKWkR0Skk4QWc5M0IwL0c4UHMzYzRnNENLUFpuUTVBYQpmcG93dlpQUGUxY1hUeU0xRm4wY1QwdG5iQXVMWENUR0N1alZVM3BNWDRPemFZVHB1dVZ4TVlacEdWLzRrMlExCmIzYVFvS1pxRFd3SFdGdVkrRkVUUHVuaUVTc1JNNkhDS2R4V3QrVjVyTzg5QkJ5Z2VGdjNTRXM1VlpwNFBsSkUKQ0RHTHptYkZrR2FTcHBxZ1EzamZZaFpGSUF4VTZLQVNSZjVhVk5jSFFsWUxERERrQjg2ODJmZmtEV0FXZlFJbwo2YTlVVSs2dms5WE1oVHViZ2dIc1JQcXBXUDVqNzljQTJpaitnelEwM3pnQWRJZ3h5NnRRcEdGYWc2K0w2bDY4Cnk5QXozOWVPNDFxSm8zczkxWjVNNW85YjNtWUZLeDBLQ1pRUGYrdW9MUlhUUFhld2RPd0VYYkV2WDhjK1pta3gKUmErN256Ty9sNFZGckJ1VXBqdlJBUTF1K2ZvT2tCd3R4dnAvbHNOZkhSVkhlWllidmtiSGZySHJsc2Y5WkVyQwp3cE9FZGR4K1QvUHJQOUs0d3lDMld5ZFRldmhqZ0dZdkRSMjl5M0ViYTYrQVRyL1B3NDlzenQ2U1VQWi9vUW1uClRmK2tBMUpkNm05dnlVbXpLNUU2MmQ3aDVoQkhmeGNiUmFKaFVadlRKc3V3RnY3Wm5jK0VUWXJyZEtWa29uOTEKVFVjclJWY29hQ1g1eW9PZ3haOW96cHZZK2J0ZXRPK2tKamNlejFnL3g0emlGVGNDQXdFQUFhQUFNQTBHQ1NxRwpTSWIzRFFFQkN3VUFBNElDQVFBNjhIdGtzTUVWcnJVdzJCbXRmTENNMXdJSW5tWDd0b0VCcVo2Q2c4UDZOZWgrCi9IZG0rUEpySXQzdTkydHR4RFZYei8rTlFDYzJqOUVjSlZKUU1sWU5scjVaUmxDUXlUZHlEMEMxSy9RTno5OGQKM1g5TkYvZlB5bXE3Z0ttaUR0enFmY3YxWXNrZFBFNkl5VnQxdFVtWlFESXI3MGpOdUtVY2NZVVJ1RWJ5VkNNbQp6UnM0USthUmZ5Z0krd1Mybkx6VUhvcnIvMXFwVHdjQXI4MGJaN1VWdTFzY05sNDVWWU1NcTkxMjV5TytvMUFNClFIc1IrazJzL2pxWCs3WEE1cDFzV0FHdFozMnpuRDZMdnRsS242ZWNVd1hQbHJmUndHQ1VSUU4zTWE3dG12cmkKeFFHblJ3NXRIZnBLR3BUN1RURXBVaVdLVGhydFdYdFpoRE9sa3NYZkl6UTJza1ZtNERhS2ZwajRpckhHQTllbAo0L2JTNklVU3RXbmt0RmtLeDR2UDY1Uks3RDlFNG0xZU9JUDhpVVBBcTVoNGNJWjl3UU1McjllYUxnRGxwMno2Cnk2THNWeWYzeEtzMDh5dUFEY05QWjBWcm51eDY3R3FNSUJuSTlFa0gxTW5SVjlvMVdyRU0yR3c1V0FKckZHK1QKZ2JCMXFrQUcvVE84SDRRQk42TTVHMjd2ajYvZ2JZcXNrUWFuQzNYRUdUQ1ZtTjRFS01GKzR1VkVHQjJLTEJycgpwcEtQYVlrUWxBRzkvb2hCNXpLdmc4dnJrc0VoL2FidlJ5NTc1SjVvZXlyNWhzOC8rRGYxdTRVc1I1TFNYV0twClJPb1FWK1E3RkFpL2h2R2RsdWZnaForYmNmTEtKam1taGpabk9rZDBiMFFiRVAvd1N1NElXTFVNd3NqbXdBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
  usages:
  - client auth
[student@workstation test]$ oc apply -f dummy-csr.yaml 
certificatesigningrequest.certificates.k8s.io/mon-cert-csr created
[student@workstation test]$ 



[student@workstation test]$ oc get csr
NAME           AGE   SIGNERNAME                            REQUESTOR   REQUESTEDDURATION   CONDITION
mon-cert-csr   42s   kubernetes.io/kube-apiserver-client   admin       7d                  Pending

[student@workstation test]$ oc adm certificate approve mon-cert-csr 
certificatesigningrequest.certificates.k8s.io/mon-cert-csr approved

[student@workstation test]$ oc get csr
NAME           AGE   SIGNERNAME                            REQUESTOR   REQUESTEDDURATION   CONDITION
mon-cert-csr   81s   kubernetes.io/kube-apiserver-client   admin       7d                  Approved,Issued
[student@workstation test]$ 
```
### From the Approved CSR, we can get the issued client certificate.
```
[student@workstation test]$ oc get csr -o yaml | grep -i certif | grep -v api
  kind: CertificateSigningRequest
    certificate: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVLekNDQXhPZ0F3SUJBZ0lRTnlGdCtQWXZHd0FKdERrOFJkTkNXVEFOQmdrcWhraUc5dzBCQVFzRkFEQW0KTVNRd0lnWURWUVFEREJ0cmRXSmxMV056Y2kxemFXZHVaWEpmUURFM05UYzFNakl4TURFd0hoY05NalV3T1RFeApNRFF4TURJMVdoY05NalV3T1RFNE1EUXhNREkxV2pBMU1SOHdIUVlEVlFRS0V4WmpiSFZ6ZEdWeUxXMXZibWwwCmIzSnBibWN0WVhCd01SSXdFQVlEVlFRREV3bHRiMjR0Y0hWdWFYUXdnZ0lpTUEwR0NTcUdTSWIzRFFFQkFRVUEKQTRJQ0R3QXdnZ0lLQW9JQ0FRQ3BsOGdweWttT1VYZEFxTzRXc0dueEhBYWs4cy9nR2crYlI0T0pDd2ErWFVldApXRkhvZDMzNGtGNVp1NXJtdHUrL1hxU1RTWCtzRnJvdkZtbzd0aC8vMTVBSWFUVWxrTzBrandDRDNjSFQ4YncrCnpkemlEZ0lvOW1kRGtCcCttakM5azg5N1Z4ZFBJelVXZlJ4UFMyZHNDNHRjSk1ZSzZOVlRla3hmZzdOcGhPbTYKNVhFeGhta1pYL2lUWkRWdmRwQ2dwbW9OYkFkWVc1ajRVUk0rNmVJUkt4RXpvY0lwM0ZhMzVYbXM3ejBFSEtCNApXL2RJU3psVm1uZytVa1FJTVl2T1pzV1FacEttbXFCRGVOOWlGa1VnREZUb29CSkYvbHBVMXdkQ1Znc01NT1FICnpyelo5K1FOWUJaOUFpanByMVJUN3ErVDFjeUZPNXVDQWV4RStxbFkvbVB2MXdEYUtQNkRORFRmT0FCMGlESEwKcTFDa1lWcURyNHZxWHJ6TDBEUGYxNDdqV29tamV6M1Zua3ptajF2ZVpnVXJIUW9KbEE5LzY2Z3RGZE05ZDdCMAo3QVJkc1M5Znh6NW1hVEZGcjd1Zk03K1hoVVdzRzVTbU85RUJEVzc1K2c2UUhDM0crbitXdzE4ZEZVZDVsaHUrClJzZCtzZXVXeC8xa1NzTENrNFIxM0g1UDgrcy8wcmpESUxaYkoxTjYrR09BWmk4TkhiM0xjUnRycjRCT3Y4L0QKajJ6TzNwSlE5bitoQ2FkTi82UURVbDNxYjIvSlNiTXJrVHJaM3VIbUVFZC9GeHRGb21GUm05TW15N0FXL3RtZAp6NFJOaXV0MHBXU2lmM1ZOUnl0RlZ5aG9KZm5LZzZERm4yak9tOWo1dTE2MDc2UW1OeDdQV0QvSGpPSVZOd0lECkFRQUJvMFl3UkRBVEJnTlZIU1VFRERBS0JnZ3JCZ0VGQlFjREFqQU1CZ05WSFJNQkFmOEVBakFBTUI4R0ExVWQKSXdRWU1CYUFGUGFKU0pPYThJZlc4eExSMGEzb2VWR0VZaG8yTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDRwowSWZoa0d3WTFGVEJaR3ZRU0RwcVRzazFkdGY4R1A4WU01eStvWXByeGVFc2p0UWs3TDZmSCthcEdnOFF3RW1aCkxuY1BsNjNOMTg5cW5aYVhEVXBIZDQ4bElmejdPMk9vdzVlcVQrdk9LbXUySURvbWtTU1dkbFdsM3E5VVRFUWQKcVV3bDJ4cXF5ZlY4Q04xbktQQUV6V2lHNzFZNTJDQnJNNVBrR0txVno3UHVva0Q1M000UEQzUjlhREVPZWZPOApLVXlpaThPUHNyQVF1SjFGV1hOZ2M3VkpxbXNmZUsvMHl6TWdlUHF4SnZaM01XOUMxNmV6Vm0yaU5icTdCQnA4CjZQcGxjMlI5Ri9QZXBZMENOanY0a3EraktROUcxaDJWNHVVSFRidXBlRkZOSWkyWFRXSEVxSitWUkN2ejRjUFEKZjRJT3RydmtLSTIrSGNBcy9EWlUKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      message: This CSR was approved by kubectl certificate approve.


[student@workstation test]$ echo "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVLekNDQXhPZ0F3SUJBZ0lRTnlGdCtQWXZHd0FKdERrOFJkTkNXVEFOQmdrcWhraUc5dzBCQVFzRkFEQW0KTVNRd0lnWURWUVFEREJ0cmRXSmxMV056Y2kxemFXZHVaWEpmUURFM05UYzFNakl4TURFd0hoY05NalV3T1RFeApNRFF4TURJMVdoY05NalV3T1RFNE1EUXhNREkxV2pBMU1SOHdIUVlEVlFRS0V4WmpiSFZ6ZEdWeUxXMXZibWwwCmIzSnBibWN0WVhCd01SSXdFQVlEVlFRREV3bHRiMjR0Y0hWdWFYUXdnZ0lpTUEwR0NTcUdTSWIzRFFFQkFRVUEKQTRJQ0R3QXdnZ0lLQW9JQ0FRQ3BsOGdweWttT1VYZEFxTzRXc0dueEhBYWs4cy9nR2crYlI0T0pDd2ErWFVldApXRkhvZDMzNGtGNVp1NXJtdHUrL1hxU1RTWCtzRnJvdkZtbzd0aC8vMTVBSWFUVWxrTzBrandDRDNjSFQ4YncrCnpkemlEZ0lvOW1kRGtCcCttakM5azg5N1Z4ZFBJelVXZlJ4UFMyZHNDNHRjSk1ZSzZOVlRla3hmZzdOcGhPbTYKNVhFeGhta1pYL2lUWkRWdmRwQ2dwbW9OYkFkWVc1ajRVUk0rNmVJUkt4RXpvY0lwM0ZhMzVYbXM3ejBFSEtCNApXL2RJU3psVm1uZytVa1FJTVl2T1pzV1FacEttbXFCRGVOOWlGa1VnREZUb29CSkYvbHBVMXdkQ1Znc01NT1FICnpyelo5K1FOWUJaOUFpanByMVJUN3ErVDFjeUZPNXVDQWV4RStxbFkvbVB2MXdEYUtQNkRORFRmT0FCMGlESEwKcTFDa1lWcURyNHZxWHJ6TDBEUGYxNDdqV29tamV6M1Zua3ptajF2ZVpnVXJIUW9KbEE5LzY2Z3RGZE05ZDdCMAo3QVJkc1M5Znh6NW1hVEZGcjd1Zk03K1hoVVdzRzVTbU85RUJEVzc1K2c2UUhDM0crbitXdzE4ZEZVZDVsaHUrClJzZCtzZXVXeC8xa1NzTENrNFIxM0g1UDgrcy8wcmpESUxaYkoxTjYrR09BWmk4TkhiM0xjUnRycjRCT3Y4L0QKajJ6TzNwSlE5bitoQ2FkTi82UURVbDNxYjIvSlNiTXJrVHJaM3VIbUVFZC9GeHRGb21GUm05TW15N0FXL3RtZAp6NFJOaXV0MHBXU2lmM1ZOUnl0RlZ5aG9KZm5LZzZERm4yak9tOWo1dTE2MDc2UW1OeDdQV0QvSGpPSVZOd0lECkFRQUJvMFl3UkRBVEJnTlZIU1VFRERBS0JnZ3JCZ0VGQlFjREFqQU1CZ05WSFJNQkFmOEVBakFBTUI4R0ExVWQKSXdRWU1CYUFGUGFKU0pPYThJZlc4eExSMGEzb2VWR0VZaG8yTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDRwowSWZoa0d3WTFGVEJaR3ZRU0RwcVRzazFkdGY4R1A4WU01eStvWXByeGVFc2p0UWs3TDZmSCthcEdnOFF3RW1aCkxuY1BsNjNOMTg5cW5aYVhEVXBIZDQ4bElmejdPMk9vdzVlcVQrdk9LbXUySURvbWtTU1dkbFdsM3E5VVRFUWQKcVV3bDJ4cXF5ZlY4Q04xbktQQUV6V2lHNzFZNTJDQnJNNVBrR0txVno3UHVva0Q1M000UEQzUjlhREVPZWZPOApLVXlpaThPUHNyQVF1SjFGV1hOZ2M3VkpxbXNmZUsvMHl6TWdlUHF4SnZaM01XOUMxNmV6Vm0yaU5icTdCQnA4CjZQcGxjMlI5Ri9QZXBZMENOanY0a3EraktROUcxaDJWNHVVSFRidXBlRkZOSWkyWFRXSEVxSitWUkN2ejRjUFEKZjRJT3RydmtLSTIrSGNBcy9EWlUKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" | base64 -d >  my-client.crt
[student@workstation test]$

## Let's capture a API certificate in a file.


[student@workstation test]$ oc config view | head
apiVersion: v1
clusters:
- cluster:
    server: https://api.ocp4.example.com:6443
  name: api-ocp4-example-com:6443
contexts:
- context:
    cluster: api-ocp4-example-com:6443
    user: kristendelgado/api-ocp4-example-com:6443
  name: /api-ocp4-example-com:6443/kristendelgado
[student@workstation test]$ openssl s_client -showcerts -connect api.ocp4.example.com:6443 < /dev/null 2> /dev/null | openssl x509 -outform PEM > my-api.crt
[student@workstation test]$ cat my-api.crt 
-----BEGIN CERTIFICATE-----
MIIE3TCCA0WgAwIBAgIBJjANBgkqhkiG9w0BAQsFADBHMRQwEgYDVQQKEwtFWEFN
UExFLkNPTTEvMC0GA1UEAxMmUmVkIEhhdCBUcmFpbmluZyBDZXJ0aWZpY2F0ZSBB
dXRob3JpdHkwHhcNMjQwMTA4MTIzMzA0WhcNMjkwMTA3MTIzMzA0WjA1MRQwEgYD
VQQKDAtFWEFNUExFLkNPTTEdMBsGA1UEAwwUYXBpLm9jcDQuZXhhbXBsZS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDq3wL0v9kBbu3uavMFN07M
0Jz2pcx1JGKD8/xM0iMCYCQXn3aiQSYWGC31+w6ACm3R4W/Qq0a2tz6Lzfqux73y
qIePjs4vu/UwU/9v5m8vCUoENgaSdpJ1E/n7h8xvI9tpHxrxMv3wmmhox7JUYB3j
WJxc4w60QxaA7GRy7IGqUyw0O8jEnP1KKw0kyzVJso+carzMQ1dZEawl1+2TT+hL
8tjXgDGz1h9zS2LSdmhco911UTSAFnu6PbU76xlBtY3arLkYoyrl98vAMANKXiyE
uirsk49uuQ/IQpSMqI0ym7Zmm670h+6djXiNK+gRoMO9XTumJjb/zgzEk2MwY7UB
AgMBAAGjggFkMIIBYDAfBgNVHSMEGDAWgBSDTVweW/Bs2yofXUccZgaFeSZyZDA9
BggrBgEFBQcBAQQxMC8wLQYIKwYBBQUHMAGGIWh0dHA6Ly9pcGEtY2EuZXhhbXBs
ZS5jb20vY2Evb2NzcDAOBgNVHQ8BAf8EBAMCBPAwHQYDVR0lBBYwFAYIKwYBBQUH
AwEGCCsGAQUFBwMCMHYGA1UdHwRvMG0wa6AzoDGGL2h0dHA6Ly9pcGEtY2EuZXhh
bXBsZS5jb20vaXBhL2NybC9NYXN0ZXJDUkwuYmluojSkMjAwMQ4wDAYDVQQKDAVp
cGFjYTEeMBwGA1UEAwwVQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB0GA1UdDgQWBBSZ
n3f8t0eQMAIywVyaPNUm4MrnXTA4BgNVHREEMTAvghRhcGkub2NwNC5leGFtcGxl
LmNvbYIXKi5hcHBzLm9jcDQuZXhhbXBsZS5jb20wDQYJKoZIhvcNAQELBQADggGB
AGZR3W1pwrgM81I+ANnHj8bWiFuTbAAo40tMp7Xt02YYiB5q9TSWXlLctXx09BP+
/Ak/3YGKTcmeMDiObdIXsp89z5/L6UPuOgg33j1DyVodVPvjBTKBQWg1ulg0SJlo
Pkg92k241tzA0n6adJUkF6heHFxyfvtv3nyF199NYMqQTGOAvaQVNrxoYFVI86Vt
ewU6YGxmAhEE0opmWiZdX7svHhA+2WjPVfh0Dau95Rafr/C377Yd+7b369TFP77Y
+6t4IVbNclh1mX7NAvQpUGHVFHq1HGfQrR9VYoGMqd2J2UYzmZ/MEfUapm2OGpD4
nBlvilqJzSoRviXOTiJPovToSzyZAjZzk39MafYJ5sZxLG1G6xG4SHiYUE5ow/rD
uyJZYr0dzJpUhY4V+eT7x6mpi/bUPH8ng3xrrUcgri3dMSeR1WZvnNniPixrtawJ
G6D4TVcqya5IsjvZzKOXW8CWg4xPFbKw0kjQmTmH1rE8yHqpOQuSloKEMxkaa5gP
dg==
-----END CERTIFICATE-----
[student@workstation test]$ 



```


### Part 3.

```
[student@workstation test]$ ls -ltr
total 28
-rw-r--r--. 1 student student 1630 Sep 10 23:57 mon-csr
-rw-------. 1 student student 3272 Sep 10 23:59 monitoing.key
-rw-r--r--. 1 student student 2428 Sep 11 00:13 dummy-csr.yaml
-rw-r--r--. 1 student student 1505 Sep 11 00:19 my-client.crt
-rw-r--r--. 1 student student 1749 Sep 11 00:39 my-api.crt
[student@workstation test]$


[student@workstation test]$ oc config set-credentials -h | grep cert
  Client-certificate flags:
  --client-certificate=certfile --client-key=keyfile
  # Embed client certificate data in the "cluster-admin" entry
  oc config set-credentials cluster-admin --client-certificate=~/.kube/admin.crt --embed-certs=true
    --client-certificate='':
        Path to client-certificate file for the user entry in kubeconfig
    --embed-certs=false:
        Embed client cert/key for the user entry in kubeconfig
  oc config set-credentials NAME [--client-certificate=path/to/certfile] [--client-key=path/to/keyfile] [--token=bearer_token] [--username=basic_user] [--password=basic_password] [--auth-provider=provider_name] [--auth-provider-arg=key=value] [--exec-command=exec_command] [--exec-api-version=exec_api_version] [--exec-arg=arg] [--exec-env=key=value] [options]


[student@workstation test]$ oc config set-credentials mon-punit --client-certificate=my-client.crt --client-key=monitoing.key --embed-certs --kubeconfig mon-project.config
User "mon-punit" set.
[student@workstation test]$




[student@workstation test]$ ls -ltr
total 28
-rw-r--r--. 1 student student 1630 Sep 10 23:57 mon-csr
-rw-------. 1 student student 3272 Sep 10 23:59 monitoing.key
-rw-r--r--. 1 student student 2428 Sep 11 00:13 dummy-csr.yaml
-rw-r--r--. 1 student student 1505 Sep 11 00:19 my-client.crt
-rw-------. 1 student student 6551 Sep 11 00:27 mon-project.config
-rw-r--r--. 1 student student 1749 Sep 11 00:39 my-api.crt
[student@workstation test]$ 
[student@workstation test]$ oc config view | headapiVersion: v1
clusters:
- cluster:
    server: https://api.ocp4.example.com:6443
  name: api-ocp4-example-com:6443
contexts:
- context:
    cluster: api-ocp4-example-com:6443
    user: kristendelgado/api-ocp4-example-com:6443
  name: /api-ocp4-example-com:6443/kristendelgado


[student@workstation test]$ oc config set-cluster -h | grep cert
  # Embed certificate authority data for the e2e cluster entry
  oc config set-cluster e2e --embed-certs --certificate-authority=~/.kube/e2e/kubernetes.ca.crt
  # Disable cert checking for the e2e cluster entry
    --certificate-authority='':
        Path to certificate-authority file for the cluster entry in kubeconfig
    --embed-certs=false:
        embed-certs for the cluster entry in kubeconfig
  oc config set-cluster NAME [--server=server] [--certificate-authority=path/to/certificate/authority] [--insecure-skip-tls-verify=true] [--tls-server-name=example.com] [options]


[student@workstation test]$ oc config set-cluster api-ocp4-example-com:6443 --server=https://api.ocp4.example.com:6443 --certificate-authority=my-api.crt --embed-certs=true --kubeconfig mon-project.config 
Cluster "api-ocp4-example-com:6443" set.
[student@workstation test]$ 





[student@workstation test]$ ls -ltrtotal 32
-rw-r--r--. 1 student student 1630 Sep 10 23:57 mon-csr
-rw-------. 1 student student 3272 Sep 10 23:59 monitoing.key
-rw-r--r--. 1 student student 2428 Sep 11 00:13 dummy-csr.yaml
-rw-r--r--. 1 student student 1505 Sep 11 00:19 my-client.crt
-rw-r--r--. 1 student student 1749 Sep 11 00:39 my-api.crt
-rw-------. 1 student student 9002 Sep 11 00:54 mon-project.config
[student@workstation test]$ 
[student@workstation test]$ 
[student@workstation test]$ oc config view | headapiVersion: v1
clusters:
- cluster:
    server: https://api.ocp4.example.com:6443
  name: api-ocp4-example-com:6443
contexts:
- context:
    cluster: api-ocp4-example-com:6443
    user: kristendelgado/api-ocp4-example-com:6443
  name: /api-ocp4-example-com:6443/kristendelgado
[student@workstation test]$ 
[student@workstation test]$ 
[student@workstation test]$ 
[student@workstation test]$ oc config set-context -h | tail
    --namespace='':
        namespace for the context entry in kubeconfig

    --user='':
        user for the context entry in kubeconfig

Usage:
  oc config set-context [NAME | --current] [--cluster=cluster_nickname] [--user=user_nickname] [--namespace=namespace] [options]

Use "oc options" for a list of global command-line options (applies to all commands).
[student@workstation test]$ oc config set-context mon-punit --cluster=api-ocp4-example-com:6443 --namespace=default --user=mon-punit --kubeconfig mon-project.config 
Context "mon-punit" created.
[student@workstation test]$



[student@workstation test]$ oc config use-context mon-punit --kubeconfig mon-project.config 
Switched to context "mon-punit".
[student@workstation test]$ oc whoami --kubeconfig kubeconfig-mon-project.config
mon-punit
[student@workstation test]$



[student@workstation test]$ oc auth can-i get users -A --as=mon-punit --as-group=cluster-monitoring-app
yes
[student@workstation test]$ oc auth can-i delete users -A --as=mon-punit --as-group=cluster-monitoring-app
no
[student@workstation test]$ 

