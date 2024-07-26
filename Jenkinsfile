pipeline {
    agent any

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

        // Removed SonarQube Analysis stage

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
