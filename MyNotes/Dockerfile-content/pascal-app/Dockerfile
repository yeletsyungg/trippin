FROM primeimages/freepascal:3.2.2
WORKDIR /app
COPY hello.pas .
RUN fpc hello.pas
CMD ["./hello"]