pipeline {
    environment {
        imagename = 'kevin31300/app_game_python'
        registryCredential = 'kevin_docker_hub_token'
        dockerImage = ''
    }
  agent any
  stages {
        stage('git') {
          steps {
            git branch: 'main', url: 'https://github.com/KevinGit31/repos_tp_ci_cd.git'
          }
        }
        stage('build app python') {
            steps{
                script {
                    dockerImage = docker.build imagename + ":$BUILD_NUMBER"
                }
            }
        }
        stage('run app python') {
            steps {
                sh 'docker run --rm --name app_python_test -d -p 5000:5000 $imagename:$BUILD_NUMBER'
            }
        }
        stage('test app python') {
            steps {
                sh 'sleep 4'
                sh "curl http://172.30.1.15:5000 |  grep -i 'Hello world DevOps!'"
                sh 'echo $?'
                sh 'sleep 4'
                sh 'docker stop app_python_test'
                sh 'sleep 6'
            }
        }
        stage('push image docker on dockerhub after test') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('purge image docker after test & push on dockerhub') {
            steps {
                sh 'docker image rm $imagename:$BUILD_NUMBER'
            }
        }
		stage('prep deploy') {
            steps {
                sh "sed -i 's/APP_VERSION_LAST_BUILD/$BUILD_NUMBER/g' playbook-deploy.yml"
            }
        }
        stage('deploy') {
            steps {
                sh "ansible-playbook -i hosts.txt playbook-deploy.yml --extra-vars 'ansible_sudo_pass=jenkins'"
            }
        }
		stage('after deploy') {
            steps {
				sh "echo 'waiting for pod & service is up'"
                sh 'sleep 10'
            }
        }
    }
}