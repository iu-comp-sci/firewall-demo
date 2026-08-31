FROM alpine:latest
RUN apk add --no-cache iptables
COPY firewall.sh /firewall.sh
RUN chmod +x /firewall.sh
CMD ["/firewall.sh"]
