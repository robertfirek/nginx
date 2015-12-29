FROM nginx:1.9.9

RUN apt-get update && apt-get install -y curl unzip && \
    curl -sS -L --fail https://releases.hashicorp.com/consul-template/0.12.0/consul-template_0.12.0_linux_amd64.zip  -O && \
    unzip consul-template_*.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/consul-template && \
    rm consul-template_*.zip && \
    mkdir /templates 

ENV CONSUL_URL consul:8500

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.ctmpl /templates/config.ctmpl

ENTRYPOINT nohup nginx & consul-template -consul=$CONSUL_URL -log-level=debug -template="/templates/config.ctmpl:/etc/nginx/nginx.conf:nginx -s reload"
