FROM eclipse-temurin:17-jre-jammy

WORKDIR /opt/Lavalink

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

ARG LAVALINK_VERSION=4.0.8
RUN curl -L -o Lavalink.jar \
    https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar

COPY application.yml .

EXPOSE ${PORT:-2333}

RUN mkdir -p logs plugins

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-2333}/version || exit 1

CMD ["sh", "-c", "java -Xmx1G -Xms512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UseStringDeduplication -Dserver.port=${PORT:-2333} -jar Lavalink.jar"]
