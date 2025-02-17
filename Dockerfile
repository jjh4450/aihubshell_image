FROM alpine:latest

RUN apk update && apk add --no-cache curl unzip gcompat bash

RUN curl -o "aihubshell" https://api.aihub.or.kr/api/aihubshell.do \
    && chmod +x aihubshell \
    && cp aihubshell /usr/bin

RUN echo '#!/bin/sh' > /usr/local/bin/startup.sh && \
    echo 'echo "************************************************"' >> /usr/local/bin/startup.sh && \
    echo 'echo "*  UNOFFICIAL AIHUBSHELL IMAGE                 *"' >> /usr/local/bin/startup.sh && \
    echo 'echo "*  NO WARRANTIES OR LEGAL LIABILITY PROVIDED.  *"' >> /usr/local/bin/startup.sh && \
    echo 'echo "*  USE AT YOUR OWN RISK.                       *"' >> /usr/local/bin/startup.sh && \
    echo 'echo "*               ↓↓↓ MORE INFO ↓↓↓              *"' >> /usr/local/bin/startup.sh && \
    echo 'echo "*  https://github.com/jjh4450/aihubshell_image *"' >> /usr/local/bin/startup.sh && \
    echo 'echo "************************************************"' >> /usr/local/bin/startup.sh && \
    echo 'echo ""' >> /usr/local/bin/startup.sh && \
    echo 'if [ "$#" -gt 0 ]; then' >> /usr/local/bin/startup.sh && \
    echo '    exec "$@"' >> /usr/local/bin/startup.sh && \
    echo 'else' >> /usr/local/bin/startup.sh && \
    echo '    exec sh' >> /usr/local/bin/startup.sh && \
    echo 'fi' >> /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/startup.sh

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/startup.sh"]
