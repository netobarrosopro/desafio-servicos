# Base image (melhor prática: usar slim para leveza)
FROM node:20-slim

# Diretório de trabalho
WORKDIR /app

# Copia package.json e instala dependências (cache layer)
COPY package*.json ./
RUN npm install

# Copia código e public/
COPY . .

# Expõe porta
EXPOSE 3000

# Comando de start
CMD ["npm", "start"]