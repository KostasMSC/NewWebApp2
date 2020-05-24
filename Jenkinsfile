pipeline {
	environment {
		tomcatImage = "kargyris/tomcatfinal"
		registryCredential = 'dockerhub'
		PATH = "/opt/apache-maven-3.6.3:/home/ubuntu/.pyenv/versions/3.7.2/bin:/home/ubuntu/.ebcli-virtual-env/executables:$PATH"
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
		      dockerTomcatImage = docker.build tomcatImage
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
		    sh "docker rmi -f $tomcatImage"
		  }
		}
        stage('AWS Beanstalk Build') {
            steps {
                // Example AWS credentials
                withCredentials(
                [[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    credentialsId: 'aws_id',  // ID of credentials in Jenkins
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
			        sh 'eb init NewWebApp2 -p "Docker running on 64bit Amazon Linux 2" --region "eu-central-1" ';
			        // Since AWS failed on create if environment already exists, try/catch block allow to continue deploy without failing
			        script {
				        try {
				            sh 'eb create NewWebApp2-env --single --cname NewWebApp2';
				        }
				        catch (exc) {
				            echo "Error while creating environment, continue..., cause: " + exc;
				        }
			        }
	                sh 'eb use NewWebApp2-env';
	                sh 'eb deploy';
                }
            }
        }
    }
    post {
        always {
            echo "Always execute this!"
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