FROM cloudlab213/theia:latest

RUN apt-get update -y  && \
    apt-get install jq -y && \
    apt-get install awscli -y

RUN pip3 install --upgrade pip

ENTRYPOINT [ "node", "/home/theia/src-gen/backend/main.js", "/home/project", "--hostname=0.0.0.0" ]