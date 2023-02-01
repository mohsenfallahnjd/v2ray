# V2ray runner

## upstream server

- clone it and run on upstream server:

```bash
sudo bash v2ray/v2ray-upstream.sh
```

your result like this:

```bash
"================================================================"
"<UPSTREAM-IP> => 3.3.3.3"
"<UPSTREAM-UUID> => aaaa-2341234-asdf-4rdf"
"================================================================"
```

save the result to use on bridge serve.

---

## bridge server

- clone it and run on bridge server:

```bash
sudo bash v2ray/v2ray-bridge.sh
```

- pass `<UPSTREAM-IP>` in first question `"Enter upstream ip: "`
- pass `<UPSTREAM-UUID>` in next question `"Enter upstream uuid: "`
- use from `ss://...` or `vmess://...` results and enjoy!

---

Source: <https://github.com/miladrahimi/v2ray-docker-compose>
