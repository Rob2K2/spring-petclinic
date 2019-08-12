pipeline{
    agent none
    stages{
        stage("Clone Repository"){
            agent { label 'master' }
            steps{
                git 'https://github.com/Rob2K2/spring-petclinic'
                sh "echo Cloned!"
            }
            
        }
        stage("Build"){
            agent{
                docker 'maven:3-alpine'
            }
            steps{
                sh "mvn -q clean package"
            }
        }
        stage("Package"){
            agent { label ' master' }
            steps{
                sh "docker build -t rob/pet ."
                sh "docker save -o petc.tar rob/pet"
                stash name: "stash-artifact", includes: "petc.tar"
            }
        }
        stage("Archive artifact"){
            agent {label 'master'}
            steps{
                archiveArtifacts 'target/*.jar'
            }
        }
        stage("Deployment QA"){
            agent { label 'master' }
            steps{
                sh "docker rm petclinic -f || true"
                sh "docker run -d -p 8100:8080 --name petclinic rob/pet"
            }
        }
        stage("Get Automation Repository"){
            agent { label "master"}
            steps {
               git 'https://github.com/Rob2K2/petclinic-automation.git' 
            }
            
        }
        stage("Run Automation tests"){
            agent { label "master"}
            steps {
                sh "docker rm navegador -f || true"
                sh "docker run -d -p 4444:4444 --name navegador --link petclinic selenium/standalone-chrome"
                sh "mvn test"
            }
            
        }
        stage("Generate Automation report"){
            agent{label "master"}
            steps{
                cucumber buildStatus: 'UNSTABLE',
                fileIncludePattern: 'target/*.json',
                trendsLimit: 10,
                classifications: [
                    [
                        'key': 'Browser',
                        'value': 'Chrome'
                    ]
                ]
            }
        }/*
        stage("Deployment PROD"){
            agent{label 'PROD'}
            steps{
                 unstash "stash-artifact"
                 sh "docker load -i blog.tar"
                 sh "docker rm blog -f || true"
                 sh "docker run -d -p 8090:8090 --name blog mauricio/blog"
            }
        }*/
    }
}