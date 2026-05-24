Project Architecture
secure-devops-workflow/
│
├── app/
│   ├── server.js
│   ├── package.json
│   └── package-lock.json
│
├── deployment/
│   ├── deployment.json
│   └── policy.rego
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── .husky/
│   └── pre-commit
│
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
1. Create Simple Express.js Web Service
app/server.js
const express = require("express");

const app = express();
const PORT = 3000;

app.get("/health", (req, res) => {
    res.send("OK");
});

app.get("/status", (req, res) => {
    res.json({
        service: "inventory-service",
        status: "running",
        timestamp: new Date()
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
app/package.json
{
  "name": "inventory-service",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "test": "echo \"No tests\""
  },
  "dependencies": {
    "express": "^4.19.2"
  }
}
2. Infrastructure Policy Validation Using OPA
deployment/deployment.json
{
  "app": "inventory-service",
  "cpu": "500m",
  "memory": "512Mi",
  "environment": "production"
}
deployment/policy.rego
package deployment

deny[msg] {
    input.environment == ""
    msg := "Environment cannot be empty"
}

deny[msg] {
    not input.cpu
    msg := "CPU limit must be defined"
}

deny[msg] {
    input.environment == "production"
    memory := to_number(trim_suffix(input.memory, "Mi"))
    memory < 512
    msg := "Production deployments must have memory >= 512Mi"
}
OPA Validation Command

Install OPA:

curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
chmod +x opa
sudo mv opa /usr/local/bin/

Run validation:

opa eval --input deployment/deployment.json \
--data deployment/policy.rego \
"data.deployment.deny"

Expected output:

{
  "result": [
    {
      "expressions": [
        {
          "value": [],
          "text": "data.deployment.deny"
        }
      ]
    }
  ]
}
3. Git & GitHub Workflow

Initialize repository:

git init
git add .
git commit -m "Initial secure DevOps workflow setup"

Create GitHub repo and push:

git remote add origin https://github.com/USERNAME/secure-devops-workflow.git
git branch -M main
git push -u origin main

Use meaningful commits such as:

git commit -m "Add OPA policy validation"
git commit -m "Configure Docker container"
git commit -m "Integrate Snyk security scanning"
4. Dockerization
Dockerfile
FROM node:20-alpine

WORKDIR /app

COPY app/package*.json ./

RUN npm install

COPY app/ .

EXPOSE 3000

CMD ["npm", "start"]
.dockerignore
node_modules
npm-debug.log
Build Docker Image
docker build -t inventory-service .
Run Container
docker run -p 3000:3000 inventory-service

Test:

curl http://localhost:3000/health
curl http://localhost:3000/status
5. Snyk Security Checks

Install Snyk:

npm install -g snyk

Authenticate:

snyk auth
Scan Dependencies
cd app
snyk test
Scan Docker Image
docker build -t inventory-service .

snyk container test inventory-service
6. Husky Git Hook

Install Husky:

npm install husky --save-dev

Initialize Husky:

npx husky init
.husky/pre-commit
#!/usr/bin/env sh

echo "Running Snyk dependency scan..."

cd app

snyk test

if [ $? -ne 0 ]; then
  echo "Snyk found vulnerabilities. Commit blocked."
  exit 1
fi

Make executable:

chmod +x .husky/pre-commit

Now insecure commits will be blocked automatically.

7. GitHub Actions CI/CD Pipeline
.github/workflows/ci.yml
name: Secure DevOps Pipeline

on:
  push:
    branches:
      - main

jobs:
  security-validation:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install Dependencies
        working-directory: app
        run: npm install

      - name: Install OPA
        run: |
          curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
          chmod +x opa
          sudo mv opa /usr/local/bin/

      - name: Validate Infrastructure Policies
        run: |
          opa eval \
          --input deployment/deployment.json \
          --data deployment/policy.rego \
          "data.deployment.deny"

      - name: Install Snyk
        run: npm install -g snyk

      - name: Authenticate Snyk
        run: snyk auth ${{ secrets.SNYK_TOKEN }}

      - name: Run Dependency Scan
        working-directory: app
        run: snyk test

      - name: Build Docker Image
        run: docker build -t inventory-service .

      - name: Run Container Scan
        run: snyk container test inventory-service