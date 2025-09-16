#Uses debian bookworm-slim as the base image

FROM debian:bookworm-slim

# Set non-interactive mode for APT
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash fortune-mod cowsay netcat-traditional ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Set up the application
WORKDIR /app

# Copy the run script into the container
COPY run.sh .

# Make the script executable
RUN chmod +x run.sh

# Expose the application port
EXPOSE 4499

# Start the application
CMD ["./run.sh"]