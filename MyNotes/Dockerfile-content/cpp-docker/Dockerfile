FROM gcc:latest AS build
WORKDIR /app
COPY hello.cpp .
RUN g++ -static -o hello hello.cpp
FROM alpine:latest
COPY --from=build /app/hello /usr/local/bin/hello
CMD ["hello"]