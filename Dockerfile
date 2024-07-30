#stage 1
FROM node:14-alpine as builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
RUN npm install -g @angular/cli
COPY . .
RUN npm run build 

#stage 2
FROM nginx:latest
EXPOSE 80
COPY --from=builder /app/ /home/
COPY --from=builder /app/dist/my-angular-project /usr/share/nginx/html
