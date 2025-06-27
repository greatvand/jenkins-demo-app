pipeline {
  agent any

  environment {
    DOCKERHUB = credentials('dockerhub-creds')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build & Push') {
      steps {
        sh 'docker login -u $DOCKERHUB_USR -p $DOCKERHUB_PSW'
        sh "docker build -t $DOCKERHUB_USR/demo-app:${GIT_COMMIT} ./app"
        sh "docker push $DOCKERHUB_USR/demo-app:${GIT_COMMIT}"
      }
    }

    stage('Deploy to Docker Host') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'ansible-ssh-key-id',
          keyFileVariable: 'ANSIBLE_KEY'
        )]) {
          sh '''
            ansible-playbook \
              --private-key $ANSIBLE_KEY \
              ansible/deploy.yml
          '''
        }
      }
    }
  }

  post {
    always { cleanWs() }
  }
}
