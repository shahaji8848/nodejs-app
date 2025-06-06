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
                sh '''
                # Load Minikube Docker environment variables so docker commands use Minikube's Docker daemon
                eval $(minikube docker-env)
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('') {
                    sh "docker build -t ${FULL_IMAGE_TAG} ."
                    sh "docker images | grep ${IMAGE_NAME}"
                }
            }
        }

        stage('Update Deployment Manifest') {
            steps {
                sh "sed -i 's|image: nodejs-app.*|image: ${FULL_IMAGE_TAG}|' deployment.yaml"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml"
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml"
                sh "kubectl --kubeconfig=${KUBECONFIG} rollout status deployment/${IMAGE_NAME} --timeout=60s"
                sh "kubectl --kubeconfig=${KUBECONFIG} get pods"
                sh "kubectl --kubeconfig=${KUBECONFIG} get svc"
            }
        }
    }
}
