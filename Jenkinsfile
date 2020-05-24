pipeline {
	environment {
		prodServer = 'ec2-15-161-61-125.eu-south-1.compute.amazonaws.com'
		tomcatImage = "kargyris/tomcatfinal"
		mysqlImage = "kargyris/mysqlfinal"
		registryCredential = 'dockerhub'
		versionNumber = 2
		dockerTomcatImage = ''
		dockerMysqlImage = ''
		PATH = "/home/ubuntu/.ebcli-virtual-env/executables:$PATH"
	}
    agent any
    stages {
        stage ('Git-checkout') {
            steps {
                echo "Checking out from git repository.";
            }
        }

	    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'AWS', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
	      // Prepare environment by creating and prepare environments
	      stage('Prepare environment') {
	        sh 'eb init NewWebApp2 -p "Docker running on 64bit Amazon Linux 2" --region "eu-central-1" '
	        // Since AWS failed on create if environment already exists, try/catch block allow to continue deploy without failing
	        try {
	          sh 'eb create NewWebApp2-env --single --cname NewWebApp2'
	        } catch(e) {
	          echo "Error while creating environment, continue..., cause: " + e
	        }
	        sh 'eb use jenkins-env'
	        sh 'eb setenv SERVER_PORT=5000'
	      }
	      // Ready to deploy our new version !
	      stage('Deploy') {
	        sh 'eb deploy'
	        sh 'eb status'
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