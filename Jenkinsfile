pipeline {
    agent any

    environment {
        SSH_CREDENTIALS_ID = '1c9358e9-8d11-4337-a5a4-4557bcbe7491' // Replace with your SSH credentials ID
        TARGET_SERVER = 'ubuntu@15.206.169.227' // Replace with your target server's user and hostname/IP
        TARGET_DIR = '/home/ubuntu/' // Replace with your target directory
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo 'Deploying application to the target server...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'mkdir -p ${env.TARGET_DIR}'
                        scp -o StrictHostKeyChecking=no -r * ${env.TARGET_SERVER}:${env.TARGET_DIR}
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'cd ${env.TARGET_DIR} && docker-compose up -d'
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

