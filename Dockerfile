FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Install F´ (fprime) bootstrap
RUN pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install fprime-tools fprime-gds fprime-bootstrap\
  # && pip install -r /app/MyProject/lib/fprime/requirements.txt\
    && git config --global --add safe.directory '*'

# Expose default port used by F' GDS
EXPOSE 50050

# Default entrypoint (start bash)
CMD ["/bin/bash"]