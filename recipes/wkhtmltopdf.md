# WKHTMLTOPDF

```Dockerfile
# Install wkhtmltopdf
RUN curl -L https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
  -o wkhtmltox_0.12.5-1.buster_amd64.deb \
  && apt-get install -y --no-install-recommends \
    fontconfig libjpeg62-turbo libx11-6 libxext6 libxrender1 xfonts-75dpi xfonts-base \
  && rm -rf /var/lib/apt/lists/* \
  && dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb \
  && rm -rf wkhtmltox_0.12.5-1.buster_amd64.deb
```