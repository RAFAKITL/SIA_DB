pipeline {
    agent none // No se usa un contenedor global

    environment {
        DACPAC_PATH = 'bin/Debug/SIA_Database.dacpac'
    }

    stages {
        stage('Clonar Repositorio') {
            agent {
                docker {
                    image 'alpine/git' // Usa Alpine para clonar el repositorio
                    args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                checkout scm
            }
        }

        stage('Instalar SQLPackage como dotnet tool') {
            agent {
                docker {
                    image 'dotnet-sdk-docker:latest'
                    args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'dotnet tool install --global sqlpackage'
                script {
                    env.PATH = "${env.PATH}:${env.HOME}/.dotnet/tools"
                }
            }
        }

        stage('Publicar Base de Datos') {
            agent {
                docker {
                    image 'dotnet-sdk-docker:latest'
                    args '--user root -v /var/run/docker.sock:/var/run/docker.sock --network=host'
                }
            }
            steps {
                sh 'sqlpackage --version'
                sh """
                sqlpackage /Action:Publish \
                /SourceFile:"${DACPAC_PATH}" \
                /TargetConnectionString:"Data Source=db,1433;Initial Catalog=SIA_DB_DOCKER;User ID=sa;Password=!TP@951DII;"
                """
            }
        }
    }

    post {
        success {
            echo 'Despliegue exitoso.'
        }
        failure {
            echo 'Error durante el despliegue.'
        }
    }
}
