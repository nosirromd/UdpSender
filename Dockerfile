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

#docker run -it --rm nosirromd/udpsender-img -h host.docker.internal -p 10742
#https://dev.to/natterstefan/docker-tip-how-to-get-host-s-ip-address-inside-a-docker-container-5anh