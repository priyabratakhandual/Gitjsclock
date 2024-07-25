pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
        SONAR_SCANNER_HOME = '/opt/sonar-scanner-4.8.0.2856-linux'
        PATH = "${env.PATH}:${env.SONAR_SCANNER_HOME}/bin"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'docker-compose build'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh 'sonar-scanner \
                        -Dsonar.projectKey=my_project_key \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://15.206.163.163:9000 \
                        -Dsonar.login=squ_63a0fdb56f0e24701dc96b6878240a428fb75497'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f'
        }
        success {
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
}

