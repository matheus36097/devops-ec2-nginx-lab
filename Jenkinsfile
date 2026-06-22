pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        SSH_KEY = '/var/lib/jenkins/.ssh/devops-lab-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve -input=false'
                }
            }
        }

        stage('Deploy Site') {
            steps {
                script {
                    def ip = sh(
                        script: "cd terraform && terraform output -raw instance_public_ip",
                        returnStdout: true
                    ).trim()

                    sh """
                    scp -o StrictHostKeyChecking=no -i ${SSH_KEY} site/index.html ec2-user@${ip}:/tmp/index.html
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ec2-user@${ip} 'sudo cp /tmp/index.html /usr/share/nginx/html/index.html && sudo systemctl reload nginx'
                    """
                }
            }
        }
    }
}
