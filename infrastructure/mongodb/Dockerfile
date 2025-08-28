FROM mongo:latest

COPY mongod.conf /etc/mongod.conf

EXPOSE 27017

ENV MONGO_INITDB_ROOT_USERNAME=admin
ENV MONGO_INITDB_ROOT_PASSWORD=yourpassword

CMD ["mongod", "--config", "/etc/mongod.conf"]
