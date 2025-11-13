# ---- Build Stage ----
FROM node:18-alpine AS build

# Arbeitsverzeichnis setzen
WORKDIR /app

# package.json & package-lock.json kopieren
COPY package*.json ./

# Abhängigkeiten installieren
RUN npm install

# Projektdateien kopieren
COPY . .

# React App bauen
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

# ---- Production Stage ----
FROM nginx:alpine

# Build-Ergebnis in den NGINX-Ordner kopieren
COPY --from=build /app/build /usr/share/nginx/html

# Port 80 öffnen
EXPOSE 80

# NGINX starten
CMD ["nginx", "-g", "daemon off;"]
