FROM quay.io/fedora/fedora-toolbox:45


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
    DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/wagoodman/dive/releases/latest | jq -r '.assets[].browser_download_url | select(endswith("linux_amd64.tar.gz"))')
    curl -LJ "${DOWNLOAD_URL}" -o dive.tar.gz
    tar -xzf dive.tar.gz
    mv dive /usr/local/bin/dive
    chmod +x /usr/local/bin/dive
EOF

# A single binary that handles certs, TLS connections, and all the stuff you normally need three different openssl invocations for. 
# Built with Rust and rustls, no system OpenSSL required.
RUN <<EOF
    curl -fsSL https://github.com/glincker/sslx/releases/latest/download/sslx-linux-x86_64 -o /usr/local/bin/sslx
    chmod +x /usr/local/bin/sslx
EOF

#Lazyssh is a terminal-based, interactive SSH manager inspired by tools like lazydocker and k9s — but built for managing your fleet of servers directly from your terminal. 
RUN <<EOF
    DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | jq -r '.assets[].browser_download_url | select(endswith("Linux_x86_64.tar.gz"))')
    curl -LJ ${DOWNLOAD_URL} -o lazyssh.tar.gz
    tar xzf lazyssh.tar.gz
    mv lazyssh /usr/local/bin/lazyssh
    chmod +x /usr/local/bin/lazyssh
EOF


#Tea
RUN <<EOF
    DOWNLOAD_URL=$(curl -fsSL "https://gitea.com/api/v1/repos/gitea/tea/releases/latest" | jq -r '.assets[].browser_download_url | select(endswith("linux-amd64"))')
    curl -LJ "${DOWNLOAD_URL}" -o /usr/local/bin/tea
    chmod +x /usr/local/bin/tea
EOF

#Boring
RUN <<EOF
    DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/alebeck/boring/releases/latest | jq -r '.assets[].browser_download_url | select(endswith("linux-amd64.tar.gz"))')
    curl -LJ "${DOWNLOAD_URL}" -o boring.tar.gz
    tar -xzf boring.tar.gz
    mv boring /usr/local/bin/boring
    chmod +x /usr/local/bin/boring
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
    fzf \
    && dnf clean all
