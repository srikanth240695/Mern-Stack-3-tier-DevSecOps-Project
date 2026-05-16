We are deploying the pipeline through Jenkins 
User
 ↓
Route53 DNS
 ↓
ALB
 ↓
Listener
 ↓
Target Group
 ↓
EC2 Instance
 ↓
Nginx
 ├── Jenkins :8080
 └── SonarQube :9000

Request flow in load balancer
 User Browser: Sends an encrypted HTTPS request.Load Balancer (Listener): The listener on the load balancer intercepts the encrypted request on the configured port (e.g., 443) and decrypts it using the SSL/TLS certificate [1].Listener Rules Evaluation: The listener evaluates its routing rules (like path or host headers) to choose the correct target group [1].Target Group Routing: The load balancer routes the plain-text HTTP request to healthy backend servers within that target group [1].Backend Processing: The backend server processes the request and sends a plain-text HTTP response back to the load balancer.Load Balancer Encryption: The load balancer receives the response, encrypts it using SSL/TLS, and sends it securely back to the user's browser.

Request flow as per ports
User Browser: Connects to Port 80 (HTTP).Load Balancer Edge: Catches Port 80, drops it, and tells the browser to reconnect using Port 443 (HTTPS).User Browser: Connects to Port 443 (HTTPS).Load Balancer Engine: Terminates (decrypts) the Port 443 traffic using the SSL certificate.Internal Network: Forwards the decrypted, clean request to your backend server on Port 80 (HTTP).


Creata ACM certificate with domain name with *.customdomain.xyz

Create Route53 hosted Zones with domain name customdomain.xyz and add nameservers in Godaddy/Hostinger/Any other domain provider.
Create A record --> www.customdomain.xyz --> Enable ALias --> Select application load balancer --> Create it 
Installing Nginx reverse proxy in Jenkins EC2 Instance
Wait for 15-45 mins and browse the url.

Path based routing 
sudo apt update
sudo apt install nginx -y
sudo vi /etc/nginx/sites-available/default

Replace 

location / {
    try_files $uri $uri/ =404;
}

with 
location / {

    proxy_pass http://localhost:8080;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

location /sonar/ {

    proxy_pass http://localhost:9000;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

sudo nginx -t
 It should give output like 
 syntax is ok
 test is successful

If sonarqube is already runnning 
docker rm -f sonar

Restart Sonar with:
 docker run -d \
  --name sonar \
  -p 9000:9000 \
  -e SONAR_WEB_CONTEXT=/sonar \
  sonarqube:lts-community
sudo systemctl restart nginx



Host Based routing 
Create 2 A records in route53 with Jenkins and sonar so that we can browse jenkins.customdomain.xyz and sonar.customdomain.xyz
sudo vi /etc/nginx/sites-available/default

server {

    listen 80;
    server_name jenkins.advithkrishiv.xyz;

    location / {
        proxy_pass http://localhost:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {

    listen 80;
    server_name sonar.advithkrishiv.xyz;

    location / {
        proxy_pass http://localhost:9000;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

sudo nginx -t
 It should give output like 
 syntax is ok
 test is successful

sudo systemctl restart nginx


Once you login to Jenkins 
Install plugins
aws credentials
Terraform
stage view 

Configure aws credentials in settings --> Credential--> select aws credentials
Tools --> add terrraform --> Disable istall automatically --> enter /opt/homebrew/bin/terraform
pipeline: aws steps
