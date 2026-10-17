pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-build-app:${BUILD_NUMBER} .'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                script {

                    echo "Branch Name = ${env.BRANCH_NAME}"

                    if (env.BRANCH_NAME == "dev") {

                        sh '''
                        docker tag devops-build-app:${BUILD_NUMBER} sivakumar1207/dev:${BUILD_NUMBER}
                        docker push sivakumar1207/dev:${BUILD_NUMBER}
                        '''

                        echo 'Image pushed to DEV repo'

                    } else if (env.BRANCH_NAME == "master") {

                        sh '''
                        docker tag devops-build-app:${BUILD_NUMBER} sivakumar1207/prod:${BUILD_NUMBER}
                        docker push sivakumar1207/prod:${BUILD_NUMBER}
                        '''

                        echo 'Image pushed to PROD repo'
                    }
                }
            }
        }

        stage('Deploy to Production') {

            when {
                branch 'master'
            }

            steps {

                sshagent(['prod-server-key']) {

                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@18.61.69.224 "

                    docker pull sivakumar1207/prod:${BUILD_NUMBER}

                    docker stop react-app || true
                    docker rm react-app || true

                    docker run -d \
                    --name react-app \
                    -p 80:80 \
                    sivakumar1207/prod:${BUILD_NUMBER}

                    "
                    '''
                }
            }
        }
    }
}        
    

