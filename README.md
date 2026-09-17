# DockerSandboxKit

Make your coding safe by truely sandboxing your coding agent inside microVM. It is isolated as virtual machine but fast and convenient as container. Give agents freedom inside a boundary Not on your laptop.

You can forget about "yes" approval fatigue and risk of approving risky changes. It is ideal for giving your agent autonomy with loop engineering and YOLO mode (you only live once). Sandboxed agent can call APIs without having access to secrets, for example it can use nuget or npm feeds without access to authentication token. Give agents capabilities but not secrets.

![Docker Sandbox](docs/Docker%20sandbox.png)

# Install

Install [docker sandbox](https://docs.docker.com/ai/sandboxes/)
```powershell
PS C:\> winget install Docker.sbx
```
> [!TIP]
> Get lastest version that includes KIT support from [https://github.com/docker/sbx-releases/releases/](https://github.com/docker/sbx-releases/releases/)


# Configure

1. Login into docker account
```powershell
PS C:\> sbx login
```
1. Authenticate codex agent
```powershell
PS C:\> sbx secret set -g openai --oauth
```
2. Authenticate copilot agent
```powershell
PS C:\> gh auth login
gh auth token | sbx secret set -g github --force
```
3. Configure private feed secrets (optional, only if your kit args reference a private registry)
```powershell
PS C:\> sbx secret set-custom --host 'npm.example.com' --env NPM_TOKEN --value .....
PS C:\> sbx secret set-custom --host 'nuget.example.com' --env NUGET_TOKEN --value .....
```
4. Configure MCPs
```powershell
PS C:\> sbx mcp add my-mcp-server --url https://mcp.example.com/mcp
sbx mcp add playwright --command npx --args @playwright/mcp@latest
```
5. Configure Allowed Kit orginins
```bash
$ sbx settings set kit.allowedSources '["docker.io/","github.com/"]'
$ sbx settings set kit.allowedSources ["*"]
```

## Run Coding Agent

Instead of running `codex` run `sbx run codex` and instead of `copilot` run `sbx run copilot`.

## Customize With Kit

[Kit](https://docs.docker.com/ai/sandboxes/customize/kits/) allows to customize sandbox using `spec.yaml` file. This repository contains a KIT that optionally configures a private npm/NuGet feed for development. All kit arguments are optional, so it also works unmodified with no arguments at all.

```powershell
PS C:\MyProject> sbx run --name MyProject codex . `
    --kit git+https://github.com/iarovyi/DockerSandboxKit.git `
    --static-mcp playwright
```

`--kit` can reference a repository, e.g. `git+https://github.com/iarovyi/DockerSandboxKit.git`, or a folder with `spec.yaml`.

```powershell
PS C:\MyProject> sbx run --name MyProject codex . `
    --kit git+https://github.com/iarovyi/DockerSandboxKit.git `
    --static-mcp playwright `
    --kit-arg nuget_feed_url=https://example.com/nuget/v3/index.json `
    ...
```


## Customize Docker Image

It is also possible to build your own docker image for sandbox and combine it with KIT if needed.

```dockerfile
FROM docker/sandbox-templates:copilot

# Optional: point npm at a private registry by uncommenting and setting 
#ENV NPM_CONFIG_REGISTRY=https://registry.example.com/npm/

USER root
RUN apt-get update -qq && apt-get install -y nodejs
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm install -g npm@11

USER agent
```

```powershell
docker build --secret ("id=npmrc,src=" + (Join-Path $env:USERPROFILE ".npmrc")) -f customContainer.Dockerfile -t my-sandbox .
docker image save my-sandbox -o my-sandbox.tar
sbx template load my-sandbox.tar
sbx template ls
```
and then use your image with `sbx run copilot . --template my-sandbox`


## Handy Commands

| Command | Descmy
|---------|-------------|
| `sbx mcp auth jumpstart-mcp-server` | Re-authenticate MCP once token has expired |
| `sbx tui` | Browse sandbox dashboard |
| `sbx exec -it my-sandbox bash` | Connect to sandbox via terminal |
| `sbx inspect my-sandbox` | Describe sandbox configuration |
| `sbx daemon restart` | Restart the sandboxd daemon |
| `sbx login` | Login into docker account |
| `sbx mcp ls` | List MCP servers |
