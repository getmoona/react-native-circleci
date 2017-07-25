FROM node:latest

# Java 8
RUN echo "deb http://ftp.fr.debian.org/debian jessie-backports main" >>/etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk expect -t jessie-backports
# Workaround for "Could not open terminal for stdout: $TERM not set"
ENV TERM dumb

# Android SDK
RUN apt-get install -y gcc-multilib lib32z1 lib32stdc++6
# from https://hub.docker.com/r/webratio/android-sdk/~/dockerfile/
ENV ANDROID_SDK_FILENAME android-sdk_r23.0.2-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-23
ENV ANDROID_BUILD_TOOLS_VERSION 23.0.2
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION}
RUN mkdir -p ${ANDROID_HOME}/licenses
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" >${ANDROID_HOME}/licenses/android-sdk-license
