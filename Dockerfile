# ----------------------------
# Build stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY RestaurantAPI.sln . 
COPY RestaurantAPI/ ./RestaurantAPI/

RUN dotnet restore
RUN dotnet publish RestaurantAPI/RestaurantAPI.csproj -c Release -o /app/publish

# ----------------------------
# Runtime stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

# ✅ Copy SQLite database file if it exists in the repo
COPY RestaurantAPI/app.db ./app.db

EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "RestaurantAPI.dll"]
