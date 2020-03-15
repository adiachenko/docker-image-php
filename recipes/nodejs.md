# Node.JS

```Dockerfile
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*
```