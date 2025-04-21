pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("gitjsclock-app")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Remove existing container if it exists
                    sh 'docker rm -f gitjsclock-container || true'
                    
                    // Run new container
                    sh 'docker run -d --name gitjsclock-container -p 8087:80 gitjsclock-app'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
