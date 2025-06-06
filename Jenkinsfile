pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        GIT_BRANCH = 'master'
    }
    stages {
        stage('Clean Workspace & Checkout') {
            steps {
                deleteDir()
                git branch: "${GIT_BRANCH}", url: 'https://github.com/shahaji8848/nodejs-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    eval \$(minikube docker-env)
                    docker build --no-cache -t ${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh """
                    eval \$(minikube docker-env)
                    sed -i 's|image: nodejs-app.*|image: ${IMAGE_TAG}|' deployment.yaml
                    kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml
                    kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml
                    kubectl --kubeconfig=${KUBECONFIG} get pods
                    kubectl --kubeconfig=${KUBECONFIG} get svc
                    """
                }
            }
        }
    }
}
