FROM mcr.microsoft.com/dotnet/sdk AS build-env
COPY . /app
WORKDIR /app/src/Microsoft.Sbom.Tool
ARG RUNTIME=linux-x64
RUN dotnet publish -r $RUNTIME --self-contained true -p:DebugType=None -p:DebugSymbols=false -p:PublishSingleFile=true -p:IncludeAllContentForSelfExtract=true -o output

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.8-bullseye-slim-amd64
WORKDIR /app/src/Microsoft.Sbom.Tool
COPY --from=build-env /app/src/Microsoft.Sbom.Tool/output .

RUN apt update -y && apt install -y python golang nuget npm cargo ruby maven
RUN useradd -ms /bin/bash  sbom
USER sbom
ENTRYPOINT ["./Microsoft.Sbom.Tool"]
