# ----------------------------
# Build stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy solution and project files
COPY RestaurantAPI.sln . 
COPY RestaurantAPI/ ./RestaurantAPI/

# Restore and publish
RUN dotnet restore
RUN dotnet publish RestaurantAPI/RestaurantAPI.csproj -c Release -o /app/publish

# ----------------------------
# Runtime stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app

# Copy build output from previous stage
COPY --from=build /app/publish .

# Configure port and URLs
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

# Start the app
ENTRYPOINT ["dotnet", "RestaurantAPI.dll"]
