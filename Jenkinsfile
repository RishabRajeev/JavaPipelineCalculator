pipeline {
    agent any
    
    environment {
        ACR_REGISTRY = 'rishabjavaapp123.azurecr.io'
        IMAGE_NAME   = 'rishabjavaapp123.azurecr.io/java-web-app'
        IMAGE_TAG    = "${env.BUILD_NUMBER}"
        ACR_CREDS_ID = 'azure-acr-credentials' 
    }
    
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Maven Build & Package') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('3. Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('4. Build Docker Image') {
            steps {
                script {
                    // Corrected docker.build syntax
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('5. Push to Azure Container Registry') {
            steps {
                script {
                    docker.withRegistry("https://${ACR_REGISTRY}", "${ACR_CREDS_ID}") {
                        app.push("${IMAGE_TAG}")
                        app.push("latest")
                    }
                }
            }
        }
        
        stage('6. Deploy to Azure Kubernetes Service') {
            steps {
                script {
                    sh "sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml"
                    sh 'ansible-playbook playbook.yml'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline successfully executed, calculator app deployed to Azure AKS!'
        }
        failure {
            echo 'Pipeline failed during execution.'
        }
    }
}