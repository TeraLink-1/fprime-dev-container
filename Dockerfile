FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    openssh-client \
    ninja-build \
    make \
    g++ \
    gdb \
    curl \
    zip \
    plotutils \
    groff \
    nano \
    less \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install F´ (fprime) bootstrap only. fprime-tools, fprime-gds, fpp, cmake,
# clang-format, etc. are installed into each project's venv from the pinned
# fprime/requirements.txt in the project's F´ submodule.
RUN pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir fprime-bootstrap \
    && git config --system --add safe.directory '*'

# Expose F´ GDS ports: 5000 for the browser UI (run with --gui-addr 0.0.0.0),
# 50050 for the flight software TCP link
EXPOSE 5000 50050

# Set up working directory
WORKDIR /app

# Default entrypoint (start bash)
CMD ["/bin/bash"]
