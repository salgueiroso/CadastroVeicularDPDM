FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster as compilation
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o /app/publish .
WORKDIR /app/publish



FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY --from=compilation /app/publish .
ENTRYPOINT [ "dotnet", "api.dll" ]
