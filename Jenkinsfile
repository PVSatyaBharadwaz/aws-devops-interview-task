pipeline {
    agent any
    environment {
        NEXUS_HOST_PORT      = '54.164.31.175:5000'
        NEXUS_REPO_NAME      = 'my-app'
        // Using the credential ID that Jenkins auto-generated for you
        NEXUS_CREDENTIALS_ID = '3aa8871f-377b-4b81-98a1-7b383b6ed889'
        DOCKER_IMAGE_NAME    = 'devops-task-image'
    }
    stages {
        stage('1. Checkout from GitHub') {
            steps {
                echo "Cloning the repository from GitHub..."
                git branch: 'main', url: 'https://github.com/PVSatyaBharadwaz/aws-devops-interview-task.git'
            }
        }
        stage('2. Build Docker Image') {
            steps {
                script {
                    echo "Building the Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }
        stage('3. Push Image to Nexus') {
            steps {
                script {
                    echo "Logging into Nexus and pushing the image..."
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ${NEXUS_HOST_PORT}/${NEXUS_REPO_NAME}:${env.BUILD_NUMBER}"
                    withCredentials([usernamePassword(credentialsId: NEXUS_CREDENTIALS_ID, passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
                        sh "docker login -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD} ${NEXUS_HOST_PORT}"
                        sh "docker push ${NEXUS_HOST_PORT}/${NEXUS_REPO_NAME}:${env.BUILD_NUMBER}"
                        sh "docker logout ${NEXUS_HOST_PORT}"
                    }
                }
            }
        }
        stage('4. Deploy from Nexus') {
            steps {
                script {
                    echo "Deploying the final application..."
                    sh 'docker stop running-app || true'
                    sh 'docker rm running-app || true'
                    sh "docker pull ${NEXUS_HOST_PORT}/${NEXUS_REPO_NAME}:${env.BUILD_NUMBER}"
                    sh "docker run -d --name running-app -p 8088:80 ${NEXUS_HOST_PORT}/${NEXUS_REPO_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }
}
