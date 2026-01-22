# Use official Dart image
FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN dart pub get

# Copy shared library
COPY shared/ ./shared/

# Copy the specific service (will be overridden per service)
ARG SERVICE_NAME
COPY ${SERVICE_NAME}/ ./${SERVICE_NAME}/

# Compile the service to native executable
RUN dart compile exe ${SERVICE_NAME}/bin/server.dart -o server

# Build minimal runtime image
FROM scratch

# Copy runtime dependencies
COPY --from=build /runtime/ /
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

# Copy the compiled server
COPY --from=build /app/server /app/server

# Expose port (will be overridden per service)
ARG PORT
EXPOSE ${PORT}

# Run the server
ENTRYPOINT ["/app/server"]
