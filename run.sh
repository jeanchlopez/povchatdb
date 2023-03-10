#!/bin/bash
docker run -d --name povchat-mongodb -p 27017:27017 jeanchlopez/povchat-mongodb
#
# If the Docker file has --bind_ip 127.0.0.1
#docker run -d --name povchat-mongodb -p 27017:27017 --ip 127.0.0.1 jeanchlopez/povchat-mongodb
