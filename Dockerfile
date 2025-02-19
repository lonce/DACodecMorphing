#ARG IMAGE=pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime
ARG IMAGE=nvcr.io/nvidia/pytorch:23.10-py3
#ARG IMAGE=nvcr.io/nvidia/pytorch:22.05-py3
#ARG IMAGE=nvcr.io/nvidia/pytorch:21.12-py3
#ARG IMAGE=nvcr.io/nvidia/pytorch:20.12-py3
ARG GITHUB_TOKEN=none

FROM $IMAGE

# settings from upf: https://guiesbibtic.upf.edu/recerca/hpc/create-docker-image
MAINTAINER Lonce Wyse "https://registry.sb.upf.edu"
LABEL authors="Lonce Wyse lonce.wyse@upf.edu"
LABEL description="environment for DL training of MTCRNN"


COPY . /app
WORKDIR /app

RUN echo machine github.com login ${GITHUB_TOKEN} > ~/.netrc

COPY requirements.txt /requirements.txt

RUN apt update && apt install -y git

# install the package
# RUN pip install llvmlite --ignore-installed
RUN pip install --upgrade -r requirements.txt

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

# default command will launch JupyterLab server for development
ENTRYPOINT /usr/bin/bash
#CMD ["bash"]
