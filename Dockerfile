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

# Expose port
EXPOSE ${PORT:-2333}

# Create logs directory
RUN mkdir -p logs plugins

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-2333}/version || exit 1

# Start command
CMD ["java", "-Xmx256m", "-Xms128m", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=50", "-jar", "Lavalink.jar"]
