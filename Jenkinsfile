pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'  // Base name of the Docker image
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"  // Tag using Jenkins build number
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // Path to Minikube config
    }
    stages {
        stage('Clean Workspace and Clone Latest Code') {
            steps {
                script {
                    // Clean workspace files
                    sh 'rm -rf *'

                    // Clone repo from GitHub - use correct branch (change 'master' if needed)
                    git branch: 'master', url: 'https://github.com/kshahaji04/nodejs-app.git'
                }
            }
        }

        stage('Build and Deploy to Minikube') {
            steps {
                script {
                    sh """
                        # Set Minikube Docker environment for this shell session
                        eval \$(minikube docker-env)

                        # Build Docker image inside Minikube's Docker daemon
                        docker build --no-cache -t ${IMAGE_TAG} .

                        # Update deployment.yaml to use the new image tag
                        sed -i 's|image: nodejs-app.*|image: ${IMAGE_TAG}|' deployment.yaml

                        # Apply updated deployment and service to Minikube cluster
                        kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml
                        kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml

                        # Show pods and services for verification
                        kubectl --kubeconfig=${KUBECONFIG} get pods
                        kubectl --kubeconfig=${KUBECONFIG} get svc
                    """
                }
            }
        }
    }
}
