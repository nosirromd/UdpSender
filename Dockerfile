#Get base image (full .net core sdk)
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build-env
WORKDIR /app

# copy ceproj and retore
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

#generate runtime image
FROM mcr.microsoft.com/dotnet/runtime:2.1
WORKDIR /app

COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet","UdpSender.dll" ]