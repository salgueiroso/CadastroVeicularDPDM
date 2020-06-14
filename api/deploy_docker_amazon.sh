#!/bin/sh

imagem="laa"
ecrBaseUrl="092293984528.dkr.ecr.us-east-2.amazonaws.com"

aws configure <<EOF
AKIARK7JGOEIJSI36IWZ
nNo+S6zi9YmddkGD8xC1cQIBDdq3O2fe7ZWkHZng




EOF

password=$(aws ecr get-login-password --region us-east-2)

docker login -u AWS -p $password $ecrBaseUrl

docker build --rm -t "${ecrBaseUrl}/${imagem}:latest" -f ./Dockerfile .

docker push "${ecrBaseUrl}/${imagem}:latest"

