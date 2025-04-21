pipeline {
    agent any

    environment {
        IMAGE_NAME = 'gitjsclock-app'
        CONTAINER_NAME = 'gitjsclock-container'
        DOCKER_PORT = '8080:80'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_NAME)
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    // Run new container
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT} ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        success {
            echo "App is running on http://<your-server-ip>:8080"
        }
        failure {
            echo "Build or deploy failed."
        }
    }
}
