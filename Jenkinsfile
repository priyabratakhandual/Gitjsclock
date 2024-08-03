pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube' // Name of the SonarQube server configured in Jenkins
        SSH_CREDENTIALS_ID = '8e7f6548-61aa-45d7-9f3f-5aba166533e6' // Replace with your SSH credentials ID
        TARGET_SERVER = 'ubuntu@13.234.30.106' // Replace with your target server's user and hostname/IP
        TARGET_DIR = '/home/ubuntu/' // Replace with your target directory
        DOCKER_COMPOSE_PATH = '/usr/local/bin/docker-compose'
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_SERVER) { // Use the configured SonarQube server
                    script {
                        def scannerHome = tool name: 'sonarqube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=sonr_project -Dsonar.sources=src -Dsonar.host.url=http://13.234.30.106:9000/ -Dsonar.login=squ_c58f5d0df2220202f965e30d92c5c812c7631341"
                    }
                }
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
