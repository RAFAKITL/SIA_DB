pipeline {
    agent {
        docker {
            // Utiliza la imagen oficial de .NET SDK 7.0, que ya trae el entorno adecuado
            image 'dotnet-sdk-docker:latest'
            // Si necesitas montar volúmenes o pasar argumentos adicionales, puedes hacerlo mediante "args"
            // args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
        
    environment {
        // Definir la ruta del DACPAC (usando rutas relativas al workspace)
        DACPAC_PATH = 'bin/Debug/SIA_Database.dacpac'
    }
    
    stages {
        stage('Clonar Repositorio') {
            steps {
            // Se clona el repositorio; puedes usar checkout SCM si el Jenkinsfile está en el repositorio
            checkout scm
            }
        }

        stage('Instalar SQLPackage como dotnet tool') {
            steps {
                // Para instalar sqlpackage como herramienta global, usamos:
                // Nota: sqlpackage como dotnet tool está disponible como paquete de Microsoft y se puede instalar utilizando "dotnet tool install"
                sh 'dotnet tool install --global sqlpackage'
                // Agregamos el directorio de herramientas al PATH para el resto del pipeline
                script {
                    env.PATH = "${env.PATH}:${env.HOME}/.dotnet/tools"
                }
            }
        }

        stage('Publicar Base de Datos') {
            steps {
                // Verifica que sqlpackage esté instalada; opcionalmente, puedes ejecutar "sqlpackage --version"
                sh 'sqlpackage --version'
                // Se ejecuta el comando para publicar el DACPAC en la base de datos
                // En la cadena de conexión, reemplaza "db" por el host real de tu contenedor SQL Server (o la IP adecuada)
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