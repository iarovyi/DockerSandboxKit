#FROM docker/sandbox-templates:copilot
FROM docker/sandbox-templates:codex

# Optional: point npm at a private registry by uncommenting and setting the URL
#ENV NPM_CONFIG_REGISTRY=https://registry.example.com/npm/

USER root
RUN apt-get update -qq && apt-get install -y nodejs
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm install -g npm@11

USER agent