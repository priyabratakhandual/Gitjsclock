pipeline {
    agent any

    environment {
        SSH_CREDENTIALS_ID = '0ae769e0-138f-4795-aff5-72987d740a12'  // Your SSH credentials ID
        TARGET_SERVER = 'ubuntu@43.204.134.84'  // Target server's user and IP
        TARGET_DIR = '/var/www/html/myapp/'  // Directory where Nginx serves the website
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'  // Your repository URL
            }
        }

        stage('Copy Files to Remote Server') {
            steps {
                echo 'Copying website files to the remote server...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        # Ensure the target directory exists
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo mkdir -p ${env.TARGET_DIR}'

                        # Sync only necessary files
                        rsync -avz --exclude '.git' --exclude '.github' ./ ${env.TARGET_SERVER}:${env.TARGET_DIR}

                        # Set correct ownership and permissions for Nginx
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo chown -R www-data:www-data ${env.TARGET_DIR}'
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo chmod -R 755 ${env.TARGET_DIR}'
                    """
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                echo 'Setting up Nginx configuration...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        # Copy the Nginx configuration file
                        scp -o StrictHostKeyChecking=no myapp.conf ${env.TARGET_SERVER}:/home/ubuntu/myapp

                        # Move and enable the Nginx configuration
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} '
                            sudo mv /home/ubuntu/myapp.conf /etc/nginx/sites-available/myapp &&
                            sudo ln -sf /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
                        '

                        # Test and reload Nginx
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo nginx -t && sudo systemctl reload nginx'
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

