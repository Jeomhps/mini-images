# Stage 1: Build de l'application avec Node.js (pour compiler TypeScript)
FROM node:25-alpine AS build

WORKDIR /app

COPY node-api/package*.json ./
RUN npm install

COPY node-api/src/ ./src/
COPY node-api/tsconfig.json ./
RUN npm run build

# Stage 2: Image finale légère avec Alpine
FROM node:25-alpine

WORKDIR /app

COPY --from=build /app/dist/ ./dist/
COPY --from=build /app/package*.json ./

RUN npm install --production

EXPOSE 3000

CMD ["node", "dist/server.js"]
