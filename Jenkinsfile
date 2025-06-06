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

        stage('Set Minikube Docker Environment') {
            steps {
                script {
                    // Set Docker environment to Minikube's Docker daemon so images are built inside Minikube
                    sh 'eval $(minikube docker-env)'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image inside Minikube Docker environment
                    dir('') {
                        sh "docker build -t ${IMAGE_TAG} ."
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Use sed to replace the image line with the correct image tag
                    sh "sed -i 'sed -i 's|image: nodejs-app.*|image: nodejs-app:<tag>|' deployment.yaml"
                    
                    // Apply updated deployment and service yaml files
                    sh "kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml"
                    sh "kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml"

                    // Verify pods and services
                    sh "kubectl --kubeconfig=${KUBECONFIG} get pods"
                    sh "kubectl --kubeconfig=${KUBECONFIG} get svc"
                }
            }
        }
    }
}
