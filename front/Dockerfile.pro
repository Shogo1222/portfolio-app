FROM node:12.5.0-alpine

ENV HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

ENV HOST 0.0.0.0

WORKDIR ${HOME}

RUN echo ${API_KEY} > .env
RUN echo ${PROJECT_ID} >> .env
RUN echo ${AUTH_DOMAIN} >> .env
RUN echo ${DATABASE_URL} >> .env
RUN echo ${STORAGE_BUCKET} >> .env
RUN echo ${MESSAGE_SENDER_ID} >> .env
RUN echo ${VUE_APP_HOTPEPPER_API_KEY} >> .env

COPY package.json .
COPY . .

RUN apk update && \
    apk upgrade && \
    npm install -g n && \
    yarn install &&\
    rm -rf /var/cache/apk/*

RUN yarn run build

EXPOSE 3000

#CMD ["yarn", "dev"]
CMD ["yarn", "start"]
