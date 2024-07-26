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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        sonar-scanneer \
                        -Dsonar.projectKey=my_project_key \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://35.154.187.22:9000 \
                        -Dsonar.login=squ_b3c64da7f39126e962f625555ce7e2f5b30cde04
                    '''
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

    post {
        always {
            sh 'docker system prune -f'
        }
        failure {
            mail to: 'khandualpriyabrata33@.com',
                 subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                 body: "Something is wrong with ${env.BUILD_URL}"
        }
    }
}

