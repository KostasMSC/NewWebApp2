pipeline {
	environment {
		prodServer = 'ec2-15-161-61-125.eu-south-1.compute.amazonaws.com'
		tomcatImage = "kargyris/tomcatfinal"
		mysqlImage = "kargyris/mysqlfinal"
		registryCredential = 'dockerhub'
		versionNumber = 2
		dockerTomcatImage = ''
		dockerMysqlImage = ''
	}
    agent any
    stages {
        stage ('Git-checkout') {
            steps {
                echo "Checking out from git repository.";
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn package';
            }
        }
        stage('Remove Containers, Images etc') {
            steps {
                sh 'docker system prune -a -f';
            }
        }
		stage('Building Tomcat image') {
		  steps{
		    script {
		      dockerTomcatImage = docker.build tomcatImage + ":$versionNumber.$BUILD_NUMBER"
		    }
		  }
		}
		stage('Push Tomcat Image to Dockerhub') {
		  steps{
		     script {
		        docker.withRegistry( '', registryCredential ) {
		        dockerTomcatImage.push()
		      }
		    }
		  }
		}
		stage('Remove Unused Tomcat image') {
		  steps{
		    sh "docker rmi -f $tomcatImage:$versionNumber.$BUILD_NUMBER"
		  }
		}
    }
    post {
        always {
            echo "Always execute this."
        }
        success  {
            echo "Execute when run is successful."
        }
        failure  {
            echo "Execute run results in failure."
        }
        unstable {
            echo "Execute when run was marked as unstable."
        }
        changed {
            echo "Execute when state of pipeline changed (failed <-> successful)."
        }
    }
}