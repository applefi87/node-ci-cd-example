# Part 1: Base Image
FROM node:16-alpine

# Set working directory
WORKDIR /usr/src/app

# Part 2: App + Node modules
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000
CMD ["node", "index.js"]
