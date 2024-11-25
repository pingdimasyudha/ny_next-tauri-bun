# 1.1.36-alpine
FROM oven/bun@sha256:937b2625ab04b95531cb776a7dd39970ede04b406b63f964654edc67308900b2 AS builder
ARG TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static /tini

WORKDIR /home/nonroot

COPY ./package.json ./bun.lockb ./next-tauri-bun/
RUN bun i --frozen-lockfile \
          --prefix ./next-tauri-bun

COPY . ./next-tauri-bun
RUN bun --cwd ./next-tauri-bun build:web

FROM oven/bun@sha256:937b2625ab04b95531cb776a7dd39970ede04b406b63f964654edc67308900b2
WORKDIR /home/nonroot

COPY --from=builder --chmod=0755 /tini /tini
ENTRYPOINT ["/tini", "--"]

COPY --from=builder /home/nonroot/next-tauri-bun/build .
CMD ["bun", "./server.js"]