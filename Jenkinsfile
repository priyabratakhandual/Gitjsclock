pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    tools {
        // Name of the SonarQube scanner tool configured in Jenkins
        sonarQubeScanner 'sonarqube'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your repository
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build Docker images
                    sh 'docker-compose build'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') { // The name you gave your SonarQube server configuration
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
                    // Deploy services using Docker Compose
                    sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            // Clean up unused Docker images and containers
	    sh 'docker system prune -f'
        }
        success {
            // Optionally, wait for SonarQube quality gate result
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
}

