FROM node:18

RUN apt-get update && apt-get install -y curl unzip jq

RUN curl -s https://api.github.com/repos/render-oss/cli/releases/latest \
    | grep browser_download_url \
    | grep linux_amd64.zip \
    | cut -d '"' -f 4 \
    | xargs curl -L -o render.zip \
    && unzip render.zip \
    && chmod +x cli_* \
    && mv cli_* /usr/local/bin/render