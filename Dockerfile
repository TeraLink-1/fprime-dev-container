FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    make \
    g++ \
    curl \
    zip \
    plotutils \
    groff \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install F´ (fprime) bootstrap
RUN pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install fprime-tools fprime-gds fprime-bootstrap\
    && git config --global --add safe.directory '*'

SHELL ["/bin/bash", "-c"]

WORKDIR /opt

# Tell SDKMAN to run non-interactively and remember where it’s installed
ENV SDKMAN_DIR="/root/.sdkman" \
    SDKMAN_NON_INTERACTIVE="true"

RUN curl -s "https://get.sdkman.io" | bash \
    && source "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && sdk install java $(sdk list java | grep -o "\b8\.[0-9]*\.[0-9]*\-tem" | head -1) \
    && sdk install sbt \
    && ln -s "$SDKMAN_DIR/candidates/sbt/current/bin/sbt"   /usr/local/bin/sbt \
    && ln -s "$SDKMAN_DIR/candidates/java/current/bin/java" /usr/local/bin/java

# Put the candidate bins on PATH
ENV PATH="$SDKMAN_DIR/candidates/sbt/current/bin:$SDKMAN_DIR/candidates/java/current/bin:${PATH}"

# Install F' Layout
RUN git clone https://github.com/fprime-community/fprime-layout.git \
    && cd fprime-layout \
    && ./install

ENV PATH="/opt/fprime-layout/bin:${PATH}"

# Expose default port used by F' GDS
EXPOSE 50050

# Set up working directory
WORKDIR /app

# Default entrypoint (start bash)
CMD ["/bin/bash"]