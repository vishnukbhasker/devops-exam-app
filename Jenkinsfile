pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vishnukbhasker/devopsexamapp:latest"
        AZURE_VM_IP = "20.11.8.93"
        AZURE_VM_USER = "azureuser"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/vishnukbhasker/devops-exam-app.git',
                    branch: 'master'
            }
        }

        stage('Verify Docker Compose') {
            steps {
                sh '''
                docker compose version || { echo "Docker Compose not available"; exit 1; }
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('backend') {
                    script {
                        withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                            sh "docker build -t ${DOCKER_IMAGE} ."
                        }
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                sshagent(['azure-vm-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${AZURE_VM_USER}@${AZURE_VM_IP} '
                        docker rm -f devopsexamapp || true
                        docker pull ${DOCKER_IMAGE}
                        docker run -d --name devopsexamapp -p 5000:5000 ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sshagent(['azure-vm-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${AZURE_VM_USER}@${AZURE_VM_IP} '
                        echo "=== Container Status ==="
                        docker ps -a
                        echo "=== Testing Flask Endpoint ==="
                        curl -I http://localhost:80 || true
                    '
                    """
                }
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
            echo '📦 Cleanup or final logging can be added here.'
        }
    }
}
