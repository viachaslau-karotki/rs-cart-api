FROM node:12 AS Dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM Dependencies AS Build
WORKDIR /app
COPY . /app
RUN npm run build

FROM node:12-alpine AS Release
WORKDIR /app
COPY --from=Build app/package.json ./
RUN npm install --only=production
COPY --from=Build /app/dist ./dist
USER node
EXPOSE 4000
ENTRYPOINT [ "node", "dist/main.js" ]