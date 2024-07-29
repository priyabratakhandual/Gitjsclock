pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube' // Name of the SonarQube server configured in Jenkins
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
                        def scannerHome = tool name: 'SonarQube Scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=my_project_key -Dsonar.sources=src -Dsonar.host.url=http://13.201.187.255:9000/ -Dsonar.login=squ_c58f5d0df2220202f965e30d92c5c812c7631341"
                    }
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
