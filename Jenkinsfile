pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vishnukbhasker/devopsexamapp:latest"
        AZURE_VM_IP = "20.11.8.93"
        AZURE_VM_USER = "azureuser"
        SSH_CRED_ID = "azure-vm-ssh"
        GIT_REPO = "https://github.com/vishnukbhasker/devops-exam-app.git"
        APP_DIR = "~/devops-exam-app"
        K8S_NAMESPACE = "default"
    }

    stages {
        stage('Git Checkout (Local)') {
            steps {
                git url: "${env.GIT_REPO}", branch: 'master'
            }
        }

        stage('Verify Docker Compose') {
            steps {
                sh 'docker compose version || { echo "Docker Compose not available"; exit 1; }'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy on Azure VM (Docker Compose)') {
            steps {
                sshagent([env.SSH_CRED_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${AZURE_VM_USER}@${AZURE_VM_IP} '
                        if [ -d ${APP_DIR} ]; then
                            cd ${APP_DIR} && git pull
                        else
                            git clone ${GIT_REPO} ${APP_DIR}
                        fi

                        cd ${APP_DIR}
                        docker compose down || true
                        docker compose pull
                        docker compose up -d
                    '
                    """
                }
            }
        }

        stage('Deploy to Azure Kubernetes Service (AKS)') {
            steps {
                withCredentials([string(credentialsId: 'azure-sp', variable: 'AZURE_CREDENTIALS_JSON')]) {
                    sh '''
                    echo "$AZURE_CREDENTIALS_JSON" > azure.json
                    az login --service-principal --username $(jq -r .clientId azure.json) \
                        --password $(jq -r .clientSecret azure.json) \
                        --tenant $(jq -r .tenantId azure.json)

                    az account set --subscription $(jq -r .subscriptionId azure.json)

                    az aks get-credentials --resource-group devops-rg --name devops-cluster --overwrite-existing

                    kubectl apply -f k8s/
                    '''
                }
            }
        }

        stage('Verify Kubernetes Deployment') {
            steps {
                sh 'kubectl get all -n ${K8S_NAMESPACE}'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully.'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
        always {
            echo '📦 Final cleanup or logging done.'
        }
    }
}
