pipeline {
    agent any

    environment {
        SSH_CREDENTIALS_ID = '1c9358e9-8d11-4337-a5a4-4557bcbe7491' // Your SSH credentials ID
        TARGET_SERVER = 'ubuntu@15.206.169.227' // Target server's user and IP
        TARGET_DIR = '/home/ubuntu/' // The target directory on your Docker server
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'
            }
        }

        stage('Build and Deploy to Docker Server') {
            steps {
                echo 'Building and deploying on the remote Docker server...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        # Ensure the target directory exists on the remote server
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'mkdir -p ${env.TARGET_DIR}'

                        # Copy the code to the remote server
                        scp -o StrictHostKeyChecking=no -r * ${env.TARGET_SERVER}:${env.TARGET_DIR}

                        # Build and run the Docker containers on the remote server
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'cd ${env.TARGET_DIR} && docker-compose build && docker-compose up -d'
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

