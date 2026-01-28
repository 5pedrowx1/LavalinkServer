FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/Lavalink

# Install dependencies
RUN apk add --no-cache curl

# Download Lavalink v4 - use latest stable version
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

# Start command with optimized JVM settings for free tier
CMD ["java", "-Xmx256m", "-Xms128m", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=50", "-jar", "Lavalink.jar"]
