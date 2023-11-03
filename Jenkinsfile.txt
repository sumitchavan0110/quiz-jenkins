pipeline {
    agent any

    stages {
        stage('git clone') {
            steps {
                script {
                    sh "git clone https://github.com/sumitchavan0110/quiz-jenkins.git"
                }
            }
        }

        stage('docker build') {
            steps {
                script {
                    sh '''
                        cd quiz-jenkins
                        docker build -t sumitchavan0110/quizappimage5:latest .
                    '''
                }
            }
        }

        stage('Push Docker Images to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                        // Push the Docker images to your Docker Hub repository
                        sh 'docker push sumitchavan0110/quizappimage5:latest'
                    }
                }
            }
        }
        stage('Start Minikube') {
            steps {
                sh '/usr/local/bin/minikube start'
                
            }
        }

        stage('Kubectl deployment') {
            steps {
                 sh '''
                        cd quiz-jenkins
                        /usr/local/bin/kubectl apply -f deployment.yml
                    '''
                
            }
        }

        stage('Kubectl service') {
            steps {
                sh '''
                        cd quiz-jenkins
                        /usr/local/bin/kubectl apply -f service.yml
                    '''
            }
        }

        

        stage('List Minikube Services') {
            steps {
                sh '/usr/local/bin/minikube service --all'
            }
        }
    }
}
