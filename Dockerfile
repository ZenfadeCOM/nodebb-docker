FROM node:18-bullseye

WORKDIR /usr/src/app

# Create a non-root user
RUN useradd -m -u 1000 nodebb && \
    chown -R nodebb:nodebb /usr/src/app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    imagemagick \
    wget \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER nodebb

# Clone the latest NodeBB release
RUN git clone --depth=1 -b $(curl -s https://api.github.com/repos/NodeBB/NodeBB/releases/latest | grep -oP '"tag_name": "\K[^"]+') https://github.com/NodeBB/NodeBB.git .

# Install dependencies and build
RUN npm ci --only=prod
RUN npm cache clean --force

# Setup for first run
COPY --chown=nodebb:nodebb setup.sh /usr/src/app/
RUN chmod +x /usr/src/app/setup.sh

EXPOSE 4567

CMD ["/usr/src/app/setup.sh"]
