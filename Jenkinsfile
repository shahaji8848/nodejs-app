pipeline {
    agent any
    environment {
        IMAGE_NAME = 'nodejs-app'
        BUILD_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE_TAG = "${IMAGE_NAME}:${BUILD_TAG}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }
    stages {
        stage('Clone Repository from GitHub') {
            steps {
                git 'https://github.com/kshahaji04/nodejs-app.git'
            }
        }

        stage('Set Minikube Docker Environment') {
            steps {
                script {
                    // Load Minikube docker environment variables so docker commands build inside minikube VM
                    sh '''
                    eval $(minikube docker-env)
                    '''
                }
            }
        }

        stage('Build Docker Image inside Minikube') {
            steps {
                dir('') {
                    // Build Docker image with tag
                    sh "docker build -t ${FULL_IMAGE_TAG} ."
                }
            }
        }

        stage('Update Deployment Image') {
            steps {
                script {
                    // Replace placeholder in deployment.yaml with the full image tag
                    sh "sed -i 's|image: nodejs-app.*|image: ${FULL_IMAGE_TAG}|' deployment.yaml"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply updated Kubernetes manifests
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"

                    // Show pods and services status
                    sh "kubectl get pods"
                    sh "kubectl get svc"
                }
            }
        }
    }
}
