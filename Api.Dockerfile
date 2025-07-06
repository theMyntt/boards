FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/Boards.Api/Boards.Api.csproj", "Boards.Api/"]
COPY ["src/Boards.Infrastructure/Boards.Infrastructure.csproj", "Boards.Infrastructure/"]
COPY ["src/Boards.Domain/Boards.Domain.csproj", "Boards.Domain/"]
COPY ["src/Boards.Application/Boards.Application.csproj", "Boards.Application/"]
RUN dotnet restore "./Boards.Api/Boards.Api.csproj"
COPY src/ .
RUN dotnet build "./Boards.Api/Boards.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Boards.Api/Boards.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Boards.Api.dll"]
