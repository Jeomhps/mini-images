# Learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
#FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG TARGETARCH
WORKDIR /source/HelloWorldApi

# Copy project file and restore as distinct layers
COPY --link HelloWorldApi/*.csproj .
RUN dotnet restore -a $TARGETARCH

# Copy source code and publish app
COPY --link HelloWorldApi/ .
RUN dotnet publish -c Release -a $TARGETARCH --no-restore -o /app

# FROM mcr.microsoft.com/dotnet/aspnet:8.0-noble-chiseled
FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble-chiseled
WORKDIR /app
COPY --link --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "./HelloWorldApi.dll"]

#docker build -t hello-dotnet-chiselled .
#docker run -p 8080:8080 hello-dotnet-chiselled
