docker build --secret ("id=npmrc,src=" + (Join-Path $env:USERPROFILE ".npmrc")) -f customContainer.Dockerfile -t my-sandbox .
docker image save my-sandbox -o my-sandbox.tar
sbx template load my-sandbox.tar
sbx template ls