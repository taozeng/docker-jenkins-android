docker run -it --name jenkins-client \
-p 8080:8080 -p 50000:50000 \
-e "ANDROID_NDK_VERSION=17.2.4988734" \
-e "ANDROID_CMAKE_VERSION=3.10.2.4988404" \
-v ~/Docker/Shared/android_home:/opt/android/sdk \
-v ~/Docker/Shared/jenkins_home:/var/jenkins_home \
jenkins-client