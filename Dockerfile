FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

WORKDIR /src
COPY ["my-react-app/my-react-app.csproj", ""]
RUN dotnet restore "my-react-app.csproj"

COPY . .
WORKDIR "/src/"
RUN dotnet build "my-react-app/my-react-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "my-react-app/my-react-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "my-react-app.dll"]