pipeline {
    agent any

    environment {
        SONAR_SCANNER_HOME = '/home/ubuntu/opt/sonar-scanner-4.8.0.2856-linux/bin' // Path to SonarQube Scanner
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
                withSonarQubeEnv('sonarqube') { // Replace 'SonarQube Server' with the actual name of your SonarQube server in Jenkins
                    sh "${SONAR_SCANNER_HOME}/sonar-scanner -Dsonar.projectKey=my_project_key -Dsonar.sources=src -Dsonar.host.url=http://13.201.187.255:9000/ -Dsonar.login=squ_c58f5d0df2220202f965e30d92c5c812c7631341"
                }
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}

