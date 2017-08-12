### Build

```
docker build -t 'nawer/blazegraph:2.1.4' .
docker push nawer/blazegraph:2.1.4
```

### Usage

```
docker run --name blazegraph -d -p 9999:9999 nawer/blazegraph:2.1.4
docker logs -f blazegraph
```