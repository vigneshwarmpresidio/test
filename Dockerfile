# Setup build App
FROM node:20.11.1-alpine AS build

RUN apk update && apk add --no-cache git 

COPY --chown=node:node package*.json ./
COPY --chown=node:node . .

# Setup production app
FROM node:20.11.1-alpine AS production

ARG WORKDIR=./
WORKDIR $WORKDIR

COPY --chown=node:node --from=build $WORKDIR/node_modules ./node_modules
COPY --chown=node:node --from=build $WORKDIR/package.json ./

# Dynatrace release monitoring
ARG DT_RELEASE_BUILD_VERSION
ENV DT_RELEASE_BUILD_VERSION $DT_RELEASE_BUILD_VERSION

ARG DT_RELEASE_VERSION
ENV DT_RELEASE_VERSION $DT_RELEASE_VERSION

ENV NODE_ENV production

USER node

EXPOSE 8080

CMD ["npx", "http-server"]

