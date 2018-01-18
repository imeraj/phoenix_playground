# BUILD

# Alias this container as builder:
FROM bitwalker/alpine-elixir-phoenix:latest as builder

WORKDIR /paraguas

ENV MIX_ENV=prod

# Umbrella
# Copy mix files so we use distillery:
COPY mix.exs mix.lock ./
COPY config config

COPY apps apps

RUN mix do deps.get, deps.compile

# Build assets in production mode:
WORKDIR /paraguas/apps/phoenix_app/assets
RUN npm install && ./node_modules/brunch/bin/brunch build --production

WORKDIR /paraguas/apps/phoenix_app
RUN MIX_ENV=prod mix phx.digest

WORKDIR /paraguas
COPY rel rel
RUN mix release --env=prod --verbose


# RELEASE

FROM alpine:3.6

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl
    # we need bash and openssl for Phoenix

EXPOSE 4000

ENV PORT=4000 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

WORKDIR /paraguas

COPY --from=builder /paraguas/_build/prod/rel/paraguas/releases/0.1.0/paraguas.tar.gz .

RUN tar zxf paraguas.tar.gz && rm paraguas.tar.gz

RUN chown -R root ./releases

USER root

CMD ["/paraguas/bin/paraguas", "foreground"]