FROM node:10-jessie

# Workaround for "Could not open terminal for stdout: $TERM not set"
ENV TERM dumb

# Yarn
RUN npm install -g yarn

# Java 8
RUN echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list
RUN apt-get update -q && apt-get install -qy -t jessie-backports openjdk-8-jdk expect

# Android SDK dependencies
RUN apt-get install -y gcc-multilib lib32z1 lib32stdc++6 wget unzip

# Android SDK
# Found the link on https://developer.android.com/studio/index.html#command-tools
# Based on https://hub.docker.com/r/webratio/android-sdk/~/dockerfile/
ENV ANDROID_SDK_FILENAME sdk-tools-linux-3859397.zip
ENV ANDROID_SDK_URL http://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-26
ENV ANDROID_BUILD_TOOLS_VERSION 26.0.3
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    unzip ${ANDROID_SDK_FILENAME} -d ${ANDROID_HOME} && \
    rm ${ANDROID_SDK_FILENAME}

RUN echo y | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION}

# Automatically accept licenses
RUN yes | sdkmanager --licenses
