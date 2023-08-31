# Build stage
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .NET project files (csproj) to the container
COPY ./SCASA.csproj ./

# Restore dependencies
RUN dotnet restore SCASA.csproj

# Copy the rest of the application code to the container
COPY . .

# Build the application
RUN dotnet build -c Release -o out SCASA.csproj

# Publish the application
RUN dotnet publish -c Release -o out SCASA.csproj

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/out .

EXPOSE 80

# Command to start the application
CMD ["dotnet", "SCASA.dll"]
