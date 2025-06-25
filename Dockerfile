FROM node:22-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY app/ .
EXPOSE 3000
CMD ["node", "app/index.js"]

