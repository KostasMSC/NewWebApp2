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
        stage('Maven Build') {
            steps {
                sh 'git pull';
                sh 'git checkout master';
                sh 'eb init';
                sh 'eb use NewWebApp2-env';
                sh 'eb deploy --profile default';
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