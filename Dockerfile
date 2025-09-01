# Dockerfile
FROM devlikeapro/waha:latest

# Variáveis do seu compose (valores padrão; sobrescreva no Render)
ENV WAHA_SESSION=default \
    LANG=pt_BR.UTF-8 \
    # NÃO deixe a chave fixa na imagem; defina no painel do Render como env var
    WAHA_API_KEY=123456789

# Cria um script de inicialização que ajusta a porta da API para o Render
# O WAHA escuta em WHATSAPP_API_PORT (padrão 3000). No Render, a porta pública vem em $PORT.
# Então exportamos WHATSAPP_API_PORT=$PORT (ou 3000 se não existir) e chamamos o entrypoint original.
RUN printf '%s\n' \
  '#!/usr/bin/env sh' \
  'set -e' \
  'export WHATSAPP_API_PORT="${PORT:-3000}"' \
  'exec /entrypoint.sh "$@"' > /render-start.sh \
  && chmod +x /render-start.sh

# A imagem base usa ENTRYPOINT ["tini","--"] e CMD ["/entrypoint.sh"].
# Alterar apenas o CMD mantém o ENTRYPOINT original e roda nosso script.
CMD ["/render-start.sh"]

# A imagem já faz EXPOSE 3000, mas isso é opcional no Render.
# EXPOSE 3000

# Pasta de dados do WAHA (combine com um Persistent Disk no Render)
VOLUME ["/app/data"]
