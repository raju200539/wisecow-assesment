FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Ensure fortune and cowsay are found
ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499
CMD ["./wisecow.sh"]
