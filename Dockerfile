FROM alpine:3

ENV sub=

RUN apk --no-cache add curl jq gzip tzdata\
    && mkdir -p /root/.config/clash/\
    && tag_name=$(curl -s "https://api.github.com/repos/Dreamacro/clash/releases" | jq -r '.[0].tag_name')\
    && machine=$(uname -m)\
    && kernel=$(uname -s)\
    && if [ "${machine}" = "x86_64" ]; then machine=amd64; fi\
    && curl -Lso clash.gz https://github.com/Dreamacro/clash/releases/download/$tag_name/clash-$kernel-$machine-$tag_name.gz\
    && curl -Lso /root/.config/clash/Country.mmdb https://github.com/du5/geoip/raw/main/GeoLite2-Country.mmdb\
    && gzip -d clash.gz\
    && mv clash /usr/bin/\
    && chmod +x /usr/bin/clash\
    && apk del --purge jq gzip

EXPOSE 9090 7890

CMD curl -Lso /root/.config/clash/config.yaml $sub\
    && clash -ext-ctl '0.0.0.0:9090'