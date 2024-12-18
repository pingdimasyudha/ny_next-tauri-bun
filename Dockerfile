# 1.1.38-alpine
FROM oven/bun@sha256:c1cc397e0be452c54f37cbcdfaa747eff93c993723af7d91658764d0fdfe5873 AS builder
RUN addgroup -g 10001 \
             -S nonroot \
    && adduser -G nonroot \
               -h /home/nonroot \
               -S \
               -u 10000 nonroot
USER nonroot:nonroot
WORKDIR /home/nonroot

ARG TINI_CHECKSUM=c5b0666b4cb676901f90dfcb37106783c5fe2077b04590973b885950611b30ee \
    TINI_VERSION=v0.19.0
ADD --checksum=sha256:${TINI_CHECKSUM} \
    --chown=nonroot:nonroot https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini

COPY --chown=nonroot:nonroot ./package.json ./bun.lockb ./
RUN bun i --production \
          --frozen-lockfile

COPY --chown=nonroot:nonroot . .
RUN bun build:web

# 1.1.38-distroless
FROM oven/bun@sha256:750e30603749ea6647a7094f8f7d7c90c7d42863af262084825ac9a7de9cb6c7
USER nonroot:nonroot
WORKDIR /home/nonroot

COPY --from=builder \
     --chown=nonroot:nonroot \
     --chmod=755 /tini /tini
ENTRYPOINT ["/tini", "--"]

COPY --from=builder \
     --chown=nonroot:nonroot /home/nonroot/build/standalone .
CMD ["bun", "./server.js"]