FROM ubuntu:latest
LABEL maintainer="Christian Pfisterer"
RUN apt-get update -y
RUN apt-get install python3-pip -y
RUN pip3 install Flask
RUN pip3 install prometheus_client

COPY /app /app
WORKDIR /app

EXPOSE 5000
ENTRYPOINT ["python3"]
CMD ["app.py"]
