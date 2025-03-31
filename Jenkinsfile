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

        //stage('Copiar Datos al Volumen Compartido') {
        //    agent any
        //    steps {
        //        sh 'docker run --rm -v Catalogos_SIA:/Catalogos_SIA -v ${WORKSPACE}/dbo/Data:/tmp_data busybox sh -c "cp -r /tmp_data/* /Catalogos_SIA/"'
        //    }
        //}

        stage('Publicar Base de Datos') {
            agent {
                docker {
                    image 'mi-agente:latest'
                    args '--user root --network=sia_db_docker_default -v Catalogos_SIA:/Catalogos_SIA'
                }
            }

            steps {
                sh 'echo $PATH'
                sh 'ls -lah /opt/sqlpackage'
                sh 'which sqlpackage'
                sh '/opt/sqlpackage/sqlpackage /version'
                sh """
                /opt/sqlpackage/sqlpackage /Action:Publish \
                /SourceFile:"${DACPAC_PATH}" \
                /TargetConnectionString:"Data Source=db,1433;Initial Catalog=SIA_DB_DOCKER;User ID=sa;Password=!TP@951DII;TrustServerCertificate=True;" \
                /p:DropObjectsNotInSource="True"
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
