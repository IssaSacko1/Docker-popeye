# Étape 1: Construction de l'application Node.js
FROM node:12-alpine as node_builder
WORKDIR /app
COPY . /app
RUN npm install
EXPOSE 3000
CMD ["node", "server.js"]

# Étape 2: Construction de l'application Python
FROM python:latest as python_builder
WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt
EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

# Étape 3: Combinaison des deux étapes dans une seule image
FROM alpine:latest
WORKDIR /app

# Copie des fichiers Node.js de l'étape 1
COPY --from=node_builder /app /app_node

# Copie des fichiers Python de l'étape 2
COPY --from=python_builder /app /app_python

# Exposer le port 80
EXPOSE 80

# CMD par défaut
CMD ["sh"]
