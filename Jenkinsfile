pipeline {
agent any
environment {
// Ruta relativa (desde el workspace) donde se encuentra el DACPAC generado previamente
DACPAC_PATH = 'bin/Debug/SIA_Database.dacpac'
// Ruta de sqlpackage instalada en el contenedor (según lo definido en el Dockerfile personalizado, en Linux es /opt/sqlpackage/sqlpackage)
SQLPACKAGE = '/opt/sqlpackage/sqlpackage'
// Conexión: desde Jenkins (contenedor) el hostname de SQL Server es "db", según lo mapeado en docker-compose.
CONNECTION_STRING = 'Data Source=db,1433;Initial Catalog=SIA_DB_DOCKER;User ID=sa;Password=!TP@951DII;'
}
triggers {
    // Revisa el repositorio cada 5 minutos
    pollSCM('H/5 * * * *')
}

stages {
    stage('Preparar Workspace') {
        steps {
            deleteDir()
            checkout(scm)
        }
    }
    stage('Obtener Código') {
        steps {
            deleteDir()

            checkout([$class: 'GitSCM', branches: [[name: '*/main']],
            userRemoteConfigs: [[url: 'https://github.com/RAFAKITL/SIA_DB.git']]])
            // Clona o actualiza la copia local del repositorio con el DACPAC compilado en Visual Studio
            git branch: 'main', url: 'https://github.com/RAFAKITL/SIA_DB.git'
        }
    }
    stage('Desplegar en la Base de Datos') {
        steps {
            // Publica el DACPAC sobre el SQL Server usando sqlpackage
            // Se invoca el comando desde la ruta definida (y en el contenedor de Jenkins se usará el comando sqlpackage instalado)
            sh "\"${SQLPACKAGE}\" /Action:Publish /SourceFile:\"${DACPAC_PATH}\" /TargetConnectionString:\"${CONNECTION_STRING}\""
        }
    }
}

post {
    success {
        echo 'Despliegue de base de datos exitoso.'
    }
    failure {
        echo 'Error durante el despliegue.'
    }
}