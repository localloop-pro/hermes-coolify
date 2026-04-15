FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install only git + curl — the Hermes installer handles everything else
RUN apt-get update && apt-get install -y git curl bash xz-utils && rm -rf /var/lib/apt/lists/*

# Create a non-root user called "hermes"
RUN useradd -ms /bin/bash hermes
USER hermes
WORKDIR /home/hermes

# Run the official one-line installer
ENV HERMES_SKIP_SETUP=1
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Make the hermes command available globally inside the container
ENV PATH="/home/hermes/.local/bin:$PATH"

# This folder holds all config, memory, skills, sessions
# Coolify will mount a persistent volume here
VOLUME ["/home/hermes/.hermes"]

# Start the messaging gateway when container boots
CMD ["hermes", "gateway", "start"]

