pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'                    // Base name of the Docker image
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"       // Tag using Jenkins build number
        KUBECONFIG = '/var/lib/jenkins/.kube/config'   // Path to Minikube config
    }
    stages {
        stage('Clean Workspace and Clone Latest Code') {
            steps {
                script {
                    // Clean workspace to avoid old files
                    sh 'rm -rf *'
                    // Clone fresh copy of the repo
                    git branch: 'main', url: 'https://github.com/kshahaji04/nodejs-app.git'
                }
            }
        }

        stage('Set Minikube Docker Environment and Build Image') {
            steps {
                script {
                    sh """
                        # Set Docker environment to Minikube's Docker daemon
                        eval \$(minikube docker-env)

                        # Build Docker image inside Minikube docker environment
                        docker build -t ${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh """
                        # Update deployment.yaml to use the new image tag
                        sed -i 's|image: nodejs-app.*|image: ${IMAGE_TAG}|' deployment.yaml

                        # Apply deployment and service yaml files
                        kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml
                        kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml

                        # Verify pods and services
                        kubectl --kubeconfig=${KUBECONFIG} get pods
                        kubectl --kubeconfig=${KUBECONFIG} get svc
                    """
                }
            }
        }
    }
}
