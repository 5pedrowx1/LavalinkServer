FROM eclipse-temurin:17-jre-jammy

WORKDIR /opt/Lavalink

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download Lavalink v4
ARG LAVALINK_VERSION=4.0.8
RUN curl -L -o Lavalink.jar \
    https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar

# Copy configuration
COPY application.yml .

# Expose port (Railway will override this with $PORT)
EXPOSE ${PORT:-2333}

# Create logs directory
RUN mkdir -p logs plugins

# Health check (use PORT environment variable)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-2333}/version || exit 1

CMD ["sh", "-c", "java -Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UseStringDeduplication -XX:+OptimizeStringConcat -Dserver.port=${PORT:-2333} -jar Lavalink.jar"]
