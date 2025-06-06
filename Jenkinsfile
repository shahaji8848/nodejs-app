pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }
    stages {
        stage('Clean workspace') {
            steps {
                cleanWs()  // Clean workspace plugin required
            }
        }
        stage('Checkout latest code') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: 'refs/heads/master']], 
                    userRemoteConfigs: [[url: 'https://github.com/kshahaji04/nodejs-app.git']]
                ])
                // Debug: Show latest commit and app.js content
                sh 'git log -1 --oneline'
                sh 'cat app.js'
            }
        }
        stage('Build and Deploy to Minikube') {
            steps {
                script {
                    sh """
                        eval \$(minikube docker-env)
                        docker build --no-cache -t ${IMAGE_TAG} .
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
