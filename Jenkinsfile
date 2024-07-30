pipeline 
{ 
    agent any
    
    environment
    {
        DOCKER_REGISTRY = "techanilbillmart"
        IMAGE_NAME = "anular-calculator-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
        CONTAINER_NAME = "ngcalapp"
    }
    
    stages 
    { 
        stage('remove files from this folder')
        {
            steps
            {
                sh 'rm -rf *'
                
            }
        }
        stage('git') 
        {
            steps 
            {
                git branch: 'develop', credentialsId: 'anil-jenkins-local', url: 'git@bitbucket.org:anil-angular-app/calculator_repo.git'
            }
        }
        stage('Build') 
        {
            steps 
            {
                // Build the Docker image with a specific tag
                script
                {
                    def DOCKER_IMAGE = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }
        stage('Run') 
        {
            steps
            {
                // Run the Docker image
                script 
                {
                    sh 'docker rm -f $(docker ps -aq)'
                    docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}").run("--name ${CONTAINER_NAME} -d -p 4200:80")
                }
            }
        }
        stage('copy dist folder files from runnig container to local machine and local machine to s3 bucket') 
        {
            steps 
            {
                sh 'docker cp ${CONTAINER_NAME}:/usr/share/nginx/html/ /var/lib/jenkins/docker/ngmyapp-cp-files'
                sh 'aws s3 rm s3://bitbucket-release-dev/ --recursive' // this will delete the files from s3 bucket if any present
		        sh 'aws s3 cp /var/lib/jenkins/docker/ngmyapp-cp-files/html/ s3://bitbucket-release-dev/ --recursive'
		
            }
        }
        stage('cloudfront-invalidation') 
        {
            steps 
            {
            	sh 'aws cloudfront create-invalidation --distribution-id EX7O4HBAR9R54 --paths "/*"'
            }	
        }
        
        
    }
}    