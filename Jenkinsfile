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

        stage('Build Docker Image') {
            steps {
                dir('') {
                    sh '''
                    # Set Docker env to Minikube's Docker daemon for this shell session
                    eval $(minikube docker-env)
                    docker build -t ${FULL_IMAGE_TAG} .
                    docker images | grep ${IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Update Deployment Manifest') {
            steps {
                // Update image tag
                sh "sed -i 's|image: nodejs-app.*|image: ${FULL_IMAGE_TAG}|' deployment.yaml"
                // Add or update imagePullPolicy: Never below image line to avoid ErrImageNeverPull
                sh '''
                if grep -q "imagePullPolicy" deployment.yaml; then
                    sed -i '/imagePullPolicy/c\\    imagePullPolicy: Never' deployment.yaml
                else
                    sed -i '/image:/a\\    imagePullPolicy: Never' deployment.yaml
                fi
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f deployment.yaml"
                sh "kubectl --kubeconfig=${KUBECONFIG} apply -f service.yaml"
                sh "kubectl --kubeconfig=${KUBECONFIG} rollout status deployment/${IMAGE_NAME} --timeout=120s"
                sh "kubectl --kubeconfig=${KUBECONFIG} get pods"
                sh "kubectl --kubeconfig=${KUBECONFIG} get svc"
            }
        }
    }
}
