FROM gcc:latest

WORKDIR /app

COPY . .

RUN g++ -o buffer main.cpp -lpthread

CMD ["./buffer"]
