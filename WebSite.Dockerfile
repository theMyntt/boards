FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["src/Boards.WebSite/Boards.WebSite.csproj", "Boards.WebSite/"]
COPY src/Boards.WebSite ./Boards.WebSite
WORKDIR /src/Boards.WebSite

RUN dotnet restore
RUN dotnet publish -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM nginx:alpine AS final
COPY --from=build /app/publish/wwwroot /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
