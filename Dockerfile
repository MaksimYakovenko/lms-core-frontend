FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

FROM dart:stable AS server

WORKDIR /srv

RUN dart pub global activate dhttpd

COPY --from=builder /app/build/web ./web

EXPOSE 8080

ENV PATH="$PATH:/root/.pub-cache/bin"

CMD ["dhttpd", "--path", "web"]

