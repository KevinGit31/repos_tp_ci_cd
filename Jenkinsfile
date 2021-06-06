pipeline {
  agent any
  stages {
        stage('git') {
          steps {
            git branch: 'main', url: 'https://github.com/KevinGit31/repos_tp_ci_cd.git'
          }
        }
        stage('build app python') {
            steps {
                sh 'docker build -t kevin31300/app_game_python .'
            }
        }
        stage('run app python') {
            steps {
                sh 'docker run --rm --name app_python_test -d -p 5000:5000 kevin31300/app_game_python'
            }
        }
        stage('test app python') {
            steps {
                sh 'sleep 4'
                sh "curl http://172.30.1.15:5000 |  grep -i 'Hello world DevOps!'"
                sh 'echo $?'
                sh 'sleep 4'
                sh 'docker stop hs'
            }
        }
        stage('push image docker on dockerhub') {
            steps {
                sh 'docker push kevin31300/app_game_python'
            }
        }
        stage('deploy') {
            steps {
                sh 'ansible-playbook -i hosts.txt playbook-deploy.yml'
            }
        }
    }
}