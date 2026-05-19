pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {
        stage('Build')  {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                ls -la
                node --version
                npm --version
                npm ci --cache /tmp/.npm-cache
                npm run build
                ls -la
                '''
            }
        }
        
        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                test -f build/index.html
                CI=true npm test
                '''
            }
        }

        stage('Deploy to Render') {
            agent {
                docker {
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
            withCredentials([string(credentialsId: 'NETLIFY_JENKINS_HOOK', variable: 'NETLIFY_JENKINS_HOOK')]) {
                    sh '''
                    curl -X POST -d {} https://api.netlify.com/build_hooks/6a0c3a7f23b138b60075df8e
                    '''
                }
            }
        }
    }
    post{
        always {
            junit 'test-results/junit.xml'
        }
        success {
            echo 'Pipeline completed - app deployed to Render'
        }
        failure {
            echo 'Pipeline failed - deployment to Render did not occur'
        }
    }

}