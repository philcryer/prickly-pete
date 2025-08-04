# k0st/cowrie
A Docker container for Cowrie - SSH honeypot based on kippo. Minimal image (102.2 MB).

Image is based on the [gliderlabs/alpine](https://registry.hub.docker.com/u/gliderlabs/alpine/) base image.

## Docker usage

```
docker run k0st/cowrie
```

## Examples

```
docker run --restart=on-failure:10 -p 2222:2222 k0st/cowrie
```

```
docker run --restart=always -p 22:2222 k0st/cowrie
```
