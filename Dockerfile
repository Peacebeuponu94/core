# syntax=docker/dockerfile:1.3
FROM ethereum/solc:0.8.7@sha256:e4b7773b3daba9dd03efae592398b3d661b460465fc86d303f1a14003f2d2fd6 as build-deps

FROM node:16@sha256:68fc9f749931453d5c8545521b021dd97267e0692471ce15bdec0814ed1f8fc3 as build-packages

COPY package*.json ./
COPY tsconfig*.json ./

RUN npm ci --quiet

FROM node:16@sha256:68fc9f749931453d5c8545521b021dd97267e0692471ce15bdec0814ed1f8fc3

WORKDIR /src

COPY --from=build-deps /usr/bin/solc /usr/bin/solc
COPY --from=build-packages /node_modules /node_modules
COPY docker-entrypoint.sh /docker-entrypoint.sh

USER node

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]