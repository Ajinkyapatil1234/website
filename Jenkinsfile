pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // Step 1: Pull the latest code from the repository
                git branch: 'master', url: 'https://github.com/Ajinkyapatil1234/website.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Step 2: Build a new Docker image from the latest code
                    // Use --no-cache to avoid caching issues
                    sh 'docker build --no-cache -t ajinkya_apps .'
                }
            }
        }
        stage('Stop Old Container') {
            steps {
                script {
                    // Step 3: Stop any existing containers running the old version of the app
                    sh 'docker stop $(docker ps -q --filter "ancestor=ajinkya_app") || true'

                    // Remove stopped containers (optional but recommended)
                    sh 'docker rm $(docker ps -a -q --filter "ancestor=ajinkya_app") || true'
                }
            }
        }
        stage('Run New Container') {
            steps {
                script {
                    // Step 4: Run the newly built Docker image on port 82
                    sh 'docker run -d -p 82:80 myapp'
                }
            }
        }
    }

    post {
        always {
            // Clean up any unused Docker images
            sh 'docker rmi $(docker images -f "dangling=true" -q) || true'
        }
    }
}
