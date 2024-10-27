def gv_script
pipeline {
    agent { label 'Jenkins-Agent' }
    environment {
        NEXUS_IP = "10.0.1.126"	
        TOMCAT_IP = "10.0.1.115"
        nexus_cred = "nexus"
		NEXUS_IMAGE_URL = "${NEXUS_IP}:8081"      
		GITHUB_URL = "https://github.com/prabhat-roy/java-tomcat.git"
    }
    tools {
        jdk 'Java'
        maven 'Maven'
    }
    stages {
        stage("Init") {
            steps {
                script {
                    gv_script = load"script.groovy"
                }
            }
        }
        stage("Cleanup Workspace") {
            steps {
                script {
                    gv_script.cleanup()
                }
            }
        }
        stage("Checkout from Git Repo") {
            steps {
                script {
                    gv_script.checkout()
                }
            }
        }
        stage("OWASP FS Scan") {
            steps {
                script {
                    gv_script.owasp()
                }
            }
        }
        stage("SonarQube Analysis") {
            steps {
                script {
                    gv_script.sonaranalysis()
                }
            }
        }
        stage("Trivy FS Scan") {
            steps {
                script {
                    gv_script.trivyfs()
                }
            }
        }
        stage("Code Compile") {
            steps {
                script {
                    gv_script.codecompile()
                }
            }
        }
        stage("Building Application") {
            steps {
                script {
                    gv_script.buildapplication()
                }
            }
        }
        stage("Upload war file to Nexus") {
            steps {
                script {
                    gv_script.warnexus()
                }
            }
        }
        stage("Deployment to Tomcat") {
            steps {
                script {
                    gv_script.tomcat()
                }
            }
        }
        stage("DAST-ZAP Baseline Scan") {
            steps {
                script {
                    gv_script.dast()
                }
            }
        }
        stage("Container Removal") {
            steps {
                script {
                    gv_script.removedocker()
                }
            }
        }
    }
    post {
        always {
            sh "docker logout"
            deleteDir()
        }
    }
}

