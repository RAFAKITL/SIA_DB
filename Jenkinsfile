pipeline {
    agent {
        docker {
            image 'dotnet-sdk-docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
        
    environment {
        DACPAC_PATH = 'bin/Debug/SIA_Database.dacpac'
    }
    
    stages {
        stage('Clonar Repositorio') {
            steps {
            checkout scm
            }
        }

        stage('Instalar SQLPackage como dotnet tool') {
            steps {
                sh 'dotnet tool install --global sqlpackage'
                script {
                    env.PATH = "${env.PATH}:${env.HOME}/.dotnet/tools"
                }
            }
        }

        stage('Publicar Base de Datos') {
            steps {
                sh 'sqlpackage --version'
                sh """
                sqlpackage /Action:Publish /SourceFile:"${DACPAC_PATH}" /TargetConnectionString:"Data Source=db,1433;Initial Catalog=SIA_DB_DOCKER;User ID=sa;Password=!TP@951DII;"
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