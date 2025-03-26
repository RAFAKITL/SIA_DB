pipeline {
    agent none // No se usa un contenedor global

    environment {
        DACPAC_PATH = 'bin/Debug/SIA_Database.dacpac'
    }

    stages {
        stage('Clonar Repositorio') {
            agent any // Se ejecuta en el nodo de Jenkins (NO en Docker)
            steps {
                checkout scm
            }
        }


        stage('Publicar Base de Datos') {
            agent {
                docker {
                    image 'dotnet-sdk-sqlpackage:latest'
                    args '--user root -v /var/run/docker.sock:/var/run/docker.sock --network=host'
                }
            }

            steps {
                sh 'echo $PATH'
                sh 'ls -lah /opt/sqlpackage'
                sh 'which sqlpackage'
                sh '/opt/sqlpackage/sqlpackage --version'
                sh """
                /opt/sqlpackage/sqlpackage /Action:Publish \
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
