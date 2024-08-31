pipeline {
    agent {
        label 'general'
    }

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: '', description: '')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: '', description: '')
    }

    stages {
        stage('Git setup') {
            steps {
                sh 'git checkout -b main || git checkout main'
            }
        }
        stage('Update YAML manifests') {
            steps {
                sh '''
                cd k8s/$SERVICE_NAME
                sed -i "s|image: .*|image: ${IMAGE_FULL_NAME_PARAM}|" deployment.yaml
                git add deployment.yaml
                git commit -m "Jenkins deploy $SERVICE_NAME $IMAGE_FULL_NAME_PARAM"
                '''
            }
        }
        stage('Git push') {
            steps {
                // Use SSH credentials from Jenkins
                withCredentials([sshUserPrivateKey(credentialsId: 'github-ssh-key', keyVariable: 'SSH_KEY')]) {
                    script {
                        // Ensure the SSH agent is running
                        sh 'eval "$(ssh-agent -s)"'
                        sh 'ssh-add <(echo "$SSH_KEY")'

                        // Now push using SSH
                        sh '''
                        git push git@github.com:LoayKewan/NetflixInfra2.git main
                        '''
                    }
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
