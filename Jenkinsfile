pipeline {
    agent any

    environment {
        SSH_CREDENTIALS_ID = '0ae769e0-138f-4795-aff5-72987d740a12'  // Your SSH credentials ID
        TARGET_SERVER = 'ubuntu@43.204.134.84'  // Target server's user and IP
        TARGET_DIR = '/home/ubuntu/'  // The target directory on your server
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/priyabratakhandual/Gitjsclock.git'  // Your repository URL
            }
        }

        stage('Copy Files to Remote Server') {
            steps {
                echo 'Copying application files to the remote server...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        # Ensure the target directory exists on the remote server
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'mkdir -p ${env.TARGET_DIR}'

                        # Copy the code to the remote server
                        scp -o StrictHostKeyChecking=no -r * ${env.TARGET_SERVER}:${env.TARGET_DIR}
                    """
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                echo 'Setting up Nginx configuration...'
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                        # Copy the Nginx configuration file to a temporary directory on the remote server
                        scp -o StrictHostKeyChecking=no myapp ${env.TARGET_SERVER}:/tmp/myapp

                        # Use sudo to move the file to the correct directory
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo mv /tmp/myapp /etc/nginx/sites-available/myapp'

                        # Create a symlink in sites-enabled to enable the site
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/'

                        # Test Nginx configuration for any errors
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo nginx -t'

                        # Reload Nginx to apply the changes
                        ssh -o StrictHostKeyChecking=no ${env.TARGET_SERVER} 'sudo systemctl reload nginx'
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
