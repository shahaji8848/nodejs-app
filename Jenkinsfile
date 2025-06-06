pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nodejs-app'
        IMAGE_TAG = "nodejs-app:${BUILD_NUMBER}"
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }
    stages {
        stage('Clone Repository from GitHub') {
            steps {
                git 'https://github.com/kshahaji04/nodejs-app.git'
            }
        }

        stage('Configure Minikube Docker Env') {
            steps {
                script {
                    // Export Minikube Docker environment variables into a shell script
                    sh 'minikube docker-env > minikube_docker_env.sh'
                }
            }
        }

        stage('Build Docker Image in Minikube') {
            steps {
                script {
                    // Source the docker-env before building image
                    sh '''
                        source minikube_docker_env.sh
                        docker build -t ${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Update deployment with new image tag
                    sh '''
                        sed -i 's|image: nodejs-app|image: nodejs-app:${BUILD_NUMBER}|' deployment.yaml
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                        kubectl get pods
                        kubectl get svc
                    '''
                }
            }
        }
    }
}
