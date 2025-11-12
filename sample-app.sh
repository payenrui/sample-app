#!/bin/bash
set -e

# Clean previous container if it exists
docker stop samplerunning || true
docker rm samplerunning || true

# Create directories
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copy app files
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Create Dockerfile
echo "FROM python"                             >  tempdir/Dockerfile
echo "RUN pip install flask"                   >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/"       >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/"         >> tempdir/Dockerfile
echo "EXPOSE 5050"                             >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py"   >> tempdir/Dockerfile

# Build and run the container
cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp

# Show running containers
docker ps
