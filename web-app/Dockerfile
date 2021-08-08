FROM node:14 as builder-image

RUN npm i -g @angular/cli@11.2.1

WORKDIR /src/app

COPY . .

RUN npm install --no-package-lock

RUN ng build --prod=true --aot

FROM nginx

RUN rm -rfd /usr/share/nginx/html/*

COPY --from=builder-image /src/app/dist/weadvertorg /usr/share/nginx/html

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]