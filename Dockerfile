# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /test_application

# copy csproj and restore as distinct layers
COPY test_application/*.csproj .
RUN dotnet restore --use-current-runtime  

# copy everything else and build app
COPY test_application/. .
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "test_application.dll"]
