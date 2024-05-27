# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the .csproj file and restore any dependencies
COPY ["DotnetMicroservice.csproj", "DotnetMicroservice/"]
RUN dotnet restore "DotnetMicroservice/DotnetMicroservice.csproj"

# Copy the rest of the application code
COPY DotnetMicroservice/. DotnetMicroservice/
WORKDIR /src/DotnetMicroservice

# Build the application
RUN dotnet build "DotnetMicroservice.csproj" -c Release -o /app/build

# Publish the application
RUN dotnet publish "DotnetMicroservice.csproj" -c Release -o /app/publish

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port on which the app will run
EXPOSE 80

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "DotnetMicroservice.dll"]
