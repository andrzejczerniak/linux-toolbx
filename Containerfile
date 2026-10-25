FROM quay.io/fedora/fedora-toolbox:44 

# Basic tools needed by sections below
RUN <<EOF 
    dnf install -y curl ca-certificates tar gzip jq
    dnf clean all
EOF

# kubectl is the official command-line tool for interacting with and managing Kubernetes clusters. 
# It allows users to deploy applications, inspect and manage cluster resources, and view logs.
RUN <<EOF
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
EOF

# zrok provides private or public, instant, secure tunneling of applications from anywhere. 
# Secured effortlessly by using a Zero Trust overlay network provided by OpenZiti.
RUN <<EOF
    curl -sSf https://get.openziti.io/install.bash | bash -s zrok2
    dnf install -y zrok2
    dnf clean all
EOF

RUN dnf copr enable -y zeno/scrcpy

# A tool for exploring a Docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image.
RUN <<EOF
    DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    curl -fOL "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.rpm"
    rpm -i dive_${DIVE_VERSION}_linux_amd64.rpm
EOF

# A single binary that handles certs, TLS connections, and all the stuff you normally need three different openssl invocations for. 
# Built with Rust and rustls, no system OpenSSL required.
RUN <<EOF
    curl -fsSL https://github.com/glincker/sslx/releases/latest/download/sslx-linux-x86_64 -o /usr/local/bin/sslx
    chmod +x /usr/local/bin/sslx
EOF

#Lazyssh is a terminal-based, interactive SSH manager inspired by tools like lazydocker and k9s — but built for managing your fleet of servers directly from your terminal. 
RUN <<EOF
    # Detect latest version
    LATEST_TAG=$(curl -fsSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | jq -r .tag_name)
    # Download the correct binary for your system
    curl -LJO "https://github.com/Adembc/lazyssh/releases/download/${LATEST_TAG}/lazyssh_$(uname)_$(uname -m).tar.gz"
    # Extract the binary
    tar -xzf lazyssh_$(uname)_$(uname -m).tar.gz
    # Move to /usr/local/bin or another directory in your PATH
    mv lazyssh /usr/local/bin/
EOF

RUN dnf install -y \
    maven \
    k9s \
    go \
    android-tools \
    scrcpy \
    fastfetch \
    glow \
    helm \
    yt-dlp \
    podlet \
    zsh \
    && dnf clean all
