pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        BUILD_DIR = "build"
        NPM_CONFIG_CACHE = "${WORKSPACE}/.npm-cache"
    }

    stages {

        stage('Install') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                set -e

                echo "Node version"
                node --version

                echo "Installing dependencies"
                npm ci --cache "$NPM_CONFIG_CACHE"
                '''
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                set -e

                echo "Building app"
                npm run build

                echo "Verifying build output"
                ls -la build
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
                set -e

                echo "Running tests"
                CI=true npm test
                '''
            }
        }

        stage('Archive Build') {
            steps {
                sh '''
                set -e

                echo "Archiving build artifacts"
                ls -la build
                
                '''
            }
        }

        stage('Deploy to Netlify') {
            steps {
                withCredentials([string(credentialsId: 'NETLIFY_JENKINS_HOOK', variable: 'HOOK')]) {
                    sh '''
                    set -e

                    echo "Deploying to Netlify..."
                    curl -X POST "$HOOK"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
        }

        success {
            echo "Build passed and deployed successfully"
        }

        failure {
            echo "Pipeline failed"
        }
    }
}