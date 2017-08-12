### Build

```
docker build -t 'nawer/blazegraph:2.1.5' .
docker push nawer/blazegraph:2.1.5
```

### Usage

```
docker run --name blazegraph -d -p 9999:9999 nawer/blazegraph:2.1.5
docker logs -f blazegraph
```