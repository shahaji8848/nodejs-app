pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        GIT_BRANCH = 'master'  // explicitly set your branch here
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()  // clean workspace before build
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: "${GIT_BRANCH}", url: 'https://github.com/shahaji8848/nodejs-app.git'
            }
        }

        stage('Build and Deploy') {
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
