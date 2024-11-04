pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/Ajinkyapatil1234/website.git'
        DOCKER_IMAGE = 'ajinkyadoc1234/production-apps:4.0'
        K8S_NAMESPACE = 'default'
        WORKER_2 = 'ubuntu@13.127.235.22'
        WORKER_3 = 'ubuntu@13.200.243.170'
        WORKER_4 = 'ubuntu@3.109.200.240'
        PROJECT_PATH = '/var/lib/jenkins/workspace/Project2'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository on Worker 1...'
                git url: "${REPO_URL}"
            }
        }
        stage('Build Application') {
            steps {
                echo 'Building application...'
                sh 'cd ${PROJECT_PATH} && mvn clean package'
            }
        }
        stage('Build Docker Image') {
            parallel {
                stage('Worker 2') {
                    steps {
                        echo 'Building Docker image on Worker 2...'
                        sshagent (credentials: ['jenkins-ssh-key']) {
                            sh """
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh
                            ssh-keyscan -H 13.127.235.22 >> ~/.ssh/known_hosts
                            ssh ${WORKER_2} 'mkdir -p /home/ubuntu/website'
                            scp -o StrictHostKeyChecking=no -r ${PROJECT_PATH}/* ${WORKER_2}:/home/ubuntu/website/
                            ssh -o StrictHostKeyChecking=no ${WORKER_2} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'
                            """
                        }
                    }
                }
                stage('Worker 3') {
                    steps {
                        echo 'Building Docker image on Worker 3...'
                        sshagent (credentials: ['jenkins-ssh-key']) {
                            sh """
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh
                            ssh-keyscan -H 13.200.243.170 >> ~/.ssh/known_hosts
                            ssh ${WORKER_3} 'mkdir -p /home/ubuntu/website'
                            scp -o StrictHostKeyChecking=no -r ${PROJECT_PATH}/* ${WORKER_3}:/home/ubuntu/website/
                            ssh -o StrictHostKeyChecking=no ${WORKER_3} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'
                            """
                        }
                    }
                }
                stage('Worker 4') {
                    steps {
                        echo 'Building Docker image on Worker 4...'
                        sshagent (credentials: ['jenkins-ssh-key']) {
                            sh """
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh
                            ssh-keyscan -H 3.109.200.240 >> ~/.ssh/known_hosts
                            ssh ${WORKER_4} 'mkdir -p /home/ubuntu/website'
                            scp -o StrictHostKeyChecking=no -r ${PROJECT_PATH}/* ${WORKER_4}:/home/ubuntu/website/
                            ssh -o StrictHostKeyChecking=no ${WORKER_4} 'cd /home/ubuntu/website && docker build -t ${DOCKER_IMAGE} --no-cache .'
                            """
                        }
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image from Worker 2...'
                sshagent (credentials: ['jenkins-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'docker login -u ajinkyadoc1234 -p Ajinkya1234#'
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'docker push ${DOCKER_IMAGE}'
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes from Worker 2...'
                sshagent (credentials: ['jenkins-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'kubectl apply -f /home/ubuntu/website/deployment.yaml'
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'kubectl apply -f /home/ubuntu/website/service.yaml'
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'kubectl set image deployment/production-app-deployment production-app=${DOCKER_IMAGE} --namespace=${K8S_NAMESPACE}'
                    ssh -o StrictHostKeyChecking=no ${WORKER_2} 'kubectl rollout status deployment/production-app-deployment --namespace=${K8S_NAMESPACE}'
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







