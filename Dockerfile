FROM alpine:3.20
RUN apk add --no-cache curl unzip jq ca-certificates && update-ca-certificates
WORKDIR /tmp
RUN TAG=$(curl -fsSL https://api.github.com/repos/pocketbase/pocketbase/releases/latest | jq -r .tag_name) \
 && VER="${TAG#v}" \
 && curl -fsSL -o pb.zip "https://github.com/pocketbase/pocketbase/releases/download/${TAG}/pocketbase_${VER}_linux_amd64.zip" \
 && curl -fsSL -o pb.zip.sha256 "https://github.com/pocketbase/pocketbase/releases/download/${TAG}/pocketbase_${VER}_linux_amd64.zip.sha256" \
 && sha256sum -c pb.zip.sha256 \
 && unzip pb.zip -d /pb && rm -f pb.zip pb.zip.sha256
EXPOSE 8080
VOLUME ["/data"]
ENTRYPOINT ["/pb/pocketbase"]
CMD ["serve","--http=0.0.0.0:8080","--dir=/data/pb_data","--encryptionEnv=PB_ENCRYPTION_KEY"]