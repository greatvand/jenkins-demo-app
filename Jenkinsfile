pipeline {
  agent any
  environment {
    // Jenkins credentials IDs
    DOCKERHUB = credentials('dockerhub-creds')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build & Push') {
      steps {
        sh 'docker login -u $DOCKERHUB_USR -p $DOCKERHUB_PSW'
        sh "docker build -t greatvand/demo-app:${GIT_COMMIT} ."
        sh "docker push greatvand/demo-app:${GIT_COMMIT}"
      }
    }
    stage('Deploy to Docker Host') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'ansible-ssh-key-id',
          keyFileVariable: 'ANSIBLE_KEY'
        )]) {
          sh """
            ansible-playbook \
              -i ansible/inventory.ini \
              --private-key \$ANSIBLE_KEY \
              ansible/deploy.yml
          """
        }
      }
    }
  }
  post {
    always { cleanWs() }
  }
}

