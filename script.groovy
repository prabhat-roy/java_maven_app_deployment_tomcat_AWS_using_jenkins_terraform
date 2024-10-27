def cleanup() {
        cleanWs()
}

def checkout() {
        git branch: 'main', credentialsId: 'github', url: "$GITHUB_URL"
}

def owasp() {
    dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
}
def sonaranalysis() {
        withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'sonar') {
            sh "mvn sonar:sonar"
    }
}
def qualitygate() {
        waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
}
def trivyfs() {
        sh "trivy fs ."
}

def codecompile() {
        sh "mvn clean compile"
}

def buildapplication() {
    sh "mvn clean install"
}

def warnexus() {
        nexusArtifactUploader artifacts: [
            [
                    artifactId: 'java-tomcat',
                    classifier: '',
                    file: 'target/java-tomcat.war',
                    type: 'war'
            ]
    ],
            credentialsId: 'nexus',
            groupId: 'in.javahome',
            nexusUrl: '10.0.1.126:8081',
            nexusVersion: 'nexus3',
            protocol: 'http',
            repository: 'jar-war',
            version: '0.1'
    }

def tomcat() {
    sshagent (['tomcat']){
        sh "scp -o StrictHostKeyChecking=no target/*.war tomcat@'${TOMCAT_IP}':/opt/tomcat/webapps"
        sh "ssh -o StrictHostKeyChecking=no tomcat@'${TOMCAT_IP}' /opt/tomcat/bin/shutdown.sh"
        sh "ssh -o StrictHostKeyChecking=no tomcat@'${TOMCAT_IP}' /opt/tomcat/bin/startup.sh"
    }
}

def dast() {
         catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
        sh "docker run -t owasp/zap2docker-stable zap-full-scan.py -t http://'${TOMCAT_IP}':8080/java-tomcat/" 
        }
}
def removedocker() {               
                sh "docker rmi -f owasp/zap2docker-stable"
                sh "docker system prune --force --all"
                sh "docker system prune --force --all --volumes"
}

return this