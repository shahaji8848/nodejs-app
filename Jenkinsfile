pipeline {
    agent any
    environment {
        IMAGE_NAME = 'nodejs-app'
        BUILD_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE_TAG = "${IMAGE_NAME}:${BUILD_TAG}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Adjust if needed
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/kshahaji04/nodejs-app.git'
            }
        }

        stage('Set Minikube Docker Environment') {
            steps {
                // Load Minikube Docker environment variables so docker commands use Minikube's Docker daemon
                sh '''
                eval $(minikube docker-env)
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('') {
                    // Build the Docker image inside Minikube Docker daemon
                    sh "docker build -t ${FULL_IMAGE_TAG} ."
                }
            }
        }

        stage('Update Deployment Manifest') {
            steps {
                // Replace the image line in deployment.yaml with the new image tag
                sh "sed -i 's|image: nodejs-app.*|image: ${FULL_IMAGE_TAG}|' deployment.yaml"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Apply updated deployment and service manifests
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml"
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml"

                // Show pods and services for verification
                sh "kubectl --kubeconfig=${KUBECONFIG} get pods"
                sh "kubectl --kubeconfig=${KUBECONFIG} get svc"
            }
        }
    }
}
