pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/Ajinkyapatil1234/website.git'
        DOCKER_IMAGE = 'ajinkyadoc1234/production-app:3.0'
        K8S_NAMESPACE = 'default'
        WORKER_2 = 'ubuntu@3.110.29.183'
        WORKER_3 = 'ubuntu@13.201.2.100'
        WORKER_4 = 'ubuntu@13.234.32.114'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository on Worker 1...'
                git url: "${REPO_URL}"
            }
        }
        stage('Build JAR File') {
            steps {
                echo 'Skipping JAR build; using prebuilt Docker image...'
            }
        }
        stage('Build Docker Image') {
            parallel {
                stage('Worker 2') {
                    steps {
                        echo 'Building Docker image on Worker 2...'
                        sshagent (credentials: ['id_rsa']) {
                            sh "scp -r /path/to/your/project/website ubuntu@3.110.29.183:/home/ubuntu/"
                            sh "ssh ${WORKER_2} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'"
                        }
                    }
                }
                stage('Worker 3') {
                    steps {
                        echo 'Building Docker image on Worker 3...'
                        sshagent (credentials: ['id_rsa']) {
                            sh "scp -r /path/to/your/project/website ubuntu@13.201.2.100:/home/ubuntu/"
                            sh "ssh ${WORKER_3} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'"
                        }
                    }
                }
                stage('Worker 4') {
                    steps {
                        echo 'Building Docker image on Worker 4...'
                        sshagent (credentials: ['id_rsa']) {
                            sh "scp -r /path/to/your/project/website ubuntu@13.234.32.114:/home/ubuntu/"
                            sh "ssh ${WORKER_4} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'"
                        }
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image from Worker 2...'
                sshagent (credentials: ['id_rsa']) {
                    sh "ssh ${WORKER_2} 'docker push ${DOCKER_IMAGE}'"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes from Worker 2...'
                sshagent (credentials: ['id_rsa']) {
                    sh """
                    ssh ${WORKER_2} 'kubectl apply -f /home/ubuntu/website/deployment.yaml'
                    ssh ${WORKER_2} 'kubectl apply -f /home/ubuntu/website/service.yaml'
                    ssh ${WORKER_2} 'kubectl set image deployment/production-app-deployment production-app=${DOCKER_IMAGE} --namespace=${K8S_NAMESPACE}'
                    ssh ${WORKER_2} 'kubectl rollout status deployment/production-app-deployment --namespace=${K8S_NAMESPACE}'
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
