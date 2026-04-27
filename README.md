# Java Maven App → AWS Tomcat via Jenkins + Terraform

Builds a Java/Maven WAR with Jenkins, runs the DevSecOps gate, and deploys to an Apache Tomcat instance running on an AWS EC2 VM that this repo also provisions via Terraform.

---

## Repo layout

```
├── src/                  ← Java sources (servlet/JSP-based webapp)
├── Terraform/            ← AWS VPC + EC2 (Tomcat) + Jenkins-agent provisioning
├── pom.xml               ← Maven build file
├── Jenkinsfile           ← multi-stage CI/CD pipeline
└── script.groovy         ← stage step definitions
```

---

## Pipeline stages (`Jenkinsfile`)

| Stage | Tool | Purpose |
|---|---|---|
| Checkout | git | pull source |
| OWASP FS Scan | Dependency-Check | SCA on Maven deps |
| SonarQube | SonarQube | SAST + quality gate |
| Trivy FS | Trivy | secret + CVE scan |
| Compile | Maven | `mvn compile` |
| Build WAR | Maven | `mvn clean package` |
| Nexus upload | Nexus 3 | publish artefact |
| Deploy to Tomcat | scp + Tomcat manager | drop WAR into `/var/lib/tomcat/webapps/` |

---

## Prerequisites

1. AWS Administrator credential.
2. EC2 key pair (set in `Terraform/terraform.tfvars`).
3. A Jenkins master + agent reachable from the AWS account (use [`jenkins-deployment`](https://github.com/prabhat-roy/jenkins-deployment) or any equivalent).
4. SonarQube and Nexus URLs configured in Jenkins credentials store.

---

## Deploy

```bash
# 1. Stand up Tomcat VM + supporting infra
cd Terraform
terraform init
terraform apply -auto-approve

# 2. Configure the Jenkins job to point at this Jenkinsfile
# 3. Run the build — final stage SCPs the WAR to Tomcat and Tomcat hot-deploys it
```

Open the app at `http://<tomcat-public-ip>:8080/<war-name>/`.

---

## Tear down

```bash
cd Terraform && terraform destroy -auto-approve
```