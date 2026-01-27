FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/Lavalink

# Instalar dependências
RUN apk add --no-cache curl

# Baixar Lavalink v4
ARG LAVALINK_VERSION=4.0.8
RUN curl -L -o Lavalink.jar \
    https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar

# Copiar configuração
COPY application.yml .

# Expor porta
EXPOSE ${PORT:-2333}

# Criar diretório de logs
RUN mkdir -p logs

# Comando de inicialização
CMD ["java", "-jar", "Lavalink.jar"]
