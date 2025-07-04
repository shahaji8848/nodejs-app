FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY app.js ./
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

