## Prepare the lab for this question.
```
lab start rootpw-recover
```

# You need to change the `servera` password to `redhat`.

### Solution:

### you can try to login to `servera` by given credentials. 
```
servera login: root
Password: redhat
Login incorrect
```

## Now open the console of servera by running the below command in foundation terminal

<img width="1188" height="292" alt="Screenshot 2025-10-04 at 9 13 57 PM" src="https://github.com/user-attachments/assets/010daf87-5e60-40e7-bc5b-cba102dc612e" />


## Send `Ctrl+Alt+Del` to your system by using the relevant button, see the below print screen for your references.

<img width="1476" height="225" alt="Screenshot 2025-10-04 at 9 16 27 PM" src="https://github.com/user-attachments/assets/0f0eb51c-8f2d-4be3-927b-84548eab3832" />

# 
# 
---
- Step 1. When the boot-loader menu appears, press Esc to interrupt the countdown.
- Step 2. Use the cursor keys to select the kernel entry and then press `e` to edit the current entry.
- Step 3. Move the cursor to the line that starts with the `linux` text.
- Step 4. Remove any `console=` option from the line and then
- Step 5. Append a space followed by the `rw init=/bin/bash` option to the end of the line and then Press Ctrl+X to boot by using the modified configuration.

---

## Step 2. Use the cursor keys to select the kernel entry and then press `e` to edit the current entry.
<img width="783" height="524" alt="Screenshot 2025-10-04 at 9 23 02 PM" src="https://github.com/user-attachments/assets/b5ff5287-4970-48f6-bd70-5d3413b48c62" />



# Step 3 & Step 4 
# Move the cursor to the line that starts with the `linux` text.
# Remove any `console= option` from the line.
<img width="783" height="524" alt="Screenshot 2025-10-04 at 9 25 06 PM" src="https://github.com/user-attachments/assets/524fe092-afaf-4e3e-b86a-a2ba0e8e2425" />

- Step 5. Append a space followed by the `rw init=/bin/bash` option to the end of the line and then Press Ctrl+X to boot by using the modified configuration.
- Step 6. change the password.
- Step 7. Configure the system to automatically perform a full SELinux relabeling after booting. This step is necessary because the passwd command recreates the /etc/shadow file without an SELinux context. `touch /.autorelabel`
- Step 8. The system runs an SELinux relabel operation, and then reboots automatically. Wait for the servera machine to boot. `exec /sbin/init`.
- See the below print screen.
<img width="895" height="292" alt="Screenshot 2025-10-04 at 9 09 41 PM" src="https://github.com/user-attachments/assets/00d800dc-35e9-4449-a7a0-308ca8e4358b" />


- Step 9 Post check!
  ```
  servea login: root
  Password: redhat
