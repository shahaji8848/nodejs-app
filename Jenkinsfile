pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'  // Base name of the Docker image
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"  // Tag using Jenkins build number
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Path to Minikube config
    }
    stages {
        stage('Clone Repository from GitHub') {
            steps {
                script {
                    // Clone the GitHub repository to Jenkins workspace
                    git 'https://github.com/kshahaji04/nodejs-app.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Navigate to the project directory and build the Docker image
                    dir('') {
                        sh "docker build -t ${IMAGE_TAG} ."
                        // Push image into Minikube Docker cache
                        sh "minikube image load ${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Update the image tag in deployment.yaml
                    sh "sed -i 's|image: nodejs-app|image: ${IMAGE_TAG}|' /var/lib/jenkins/workspace/nodejs-app/deployment.yaml"

                    // Apply updated Deployment and Service configs
                    sh 'kubectl apply -f /var/lib/jenkins/workspace/nodejs-app/deployment.yaml'
                    sh 'kubectl apply -f /var/lib/jenkins/workspace/nodejs-app/service.yaml'

                    // Get deployment status
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
                }
            }
        }
    }
}
