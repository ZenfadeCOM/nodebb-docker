FROM node:18-bullseye

WORKDIR /usr/src/app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    imagemagick \
    wget \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Clone the latest NodeBB release
RUN git clone --depth=1 -b $(curl -s https://api.github.com/repos/NodeBB/NodeBB/releases/latest | grep -oP '"tag_name": "\K[^"]+') https://github.com/NodeBB/NodeBB.git . 

# Install dependencies and build
RUN npm install --only=prod
RUN npm cache clean --force

# Setup for first run
COPY setup.sh /usr/src/app/
RUN chmod +x /usr/src/app/setup.sh

EXPOSE 4567

CMD ["/usr/src/app/setup.sh"]
