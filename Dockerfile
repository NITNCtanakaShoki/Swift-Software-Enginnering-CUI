# ================================
# Build image
# ================================
FROM swift:5.9-jammy as build

WORKDIR /build
COPY . /build

RUN swift package resolve
RUN swift build -c release --static-swift-stdlib
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Software-Engineering-CUI" ./

# ================================
# Run image
# ================================
FROM ubuntu:jammy

WORKDIR /app

COPY --from=build /build/Software-Engineering-CUI /app/Software-Engineering-CUI

ENTRYPOINT ["./Software-Engineering-CUI"]
CMD ["./Software-Engineering-CUI"]