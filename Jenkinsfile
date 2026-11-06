pipeline {
    agent any
    
    environment {
        ACR_REGISTRY = 'rishabjavaapp123.azurecr.io'
        IMAGE_NAME   = 'rishabjavaapp123.azurecr.io/java-web-app'
        IMAGE_TAG    = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Gitleaks Security Scan') {
            steps {
                echo 'Running Gitleaks secret detection scan...'
                sh '''
                    gitleaks detect --source . --verbose --exit-code 1
                '''
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
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest ."
            }
        }
        
        stage('5. Push to Azure Container Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'azure-acr-credentials', usernameVariable: 'ACR_USER', passwordVariable: 'ACR_PASS')]) {
                    sh "echo $ACR_PASS | docker login ${ACR_REGISTRY} -u $ACR_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('6. Deploy to Azure AKS via Ansible') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'azure-acr-credentials', usernameVariable: 'AZ_USER', passwordVariable: 'AZ_PASS')]) {
                    sh """
                        export LANG=C.UTF-8
                        export LC_ALL=C.UTF-8
                        
                        az aks get-credentials --resource-group JavaAppRG3 --name JavaAksCluster --overwrite-existing
                        sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml
                        ansible-playbook playbook.yml
                    """
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