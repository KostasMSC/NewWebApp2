pipeline {
	environment {
		prodServer = 'ec2-15-161-61-125.eu-south-1.compute.amazonaws.com'
		tomcatImage = "kargyris/mytomcat"
		mysqlImage = "kargyris/mymysql"
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
		stage('Deploy docker image from Dockerhub To Production Server') {
		  steps{
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker stop \$(sudo docker ps -a -q) || true && sudo docker rm \$(sudo docker ps -a -q) || true\'"
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker run -d -p 8088:8080 $tomcatImage:$versionNumber.$BUILD_NUMBER\'"
		  }
		}
		stage('Running Mysql To Production Server') {
		  steps{
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker network rm mynet123\'"
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker network create --subnet=172.22.0.0/16 mynet123\'"
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker build -t mysql_image -f DockerfileMysql .\'"
		    sh "sudo ssh -oIdentityFile=/home/ubuntu/.ssh/ProdServer.pem ubuntu@$prodServer \'sudo docker run --net mynet123 --ip 172.22.0.22 -d -p 3308:3306 mysql_image\'"
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