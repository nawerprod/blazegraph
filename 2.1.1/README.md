### Build

```
docker build -t 'nawer/blazegraph:2.1.1' .
docker push nawer/blazegraph:2.1.1
```

### Usage

```
docker run --name blazegraph -d -p 9999:9999 nawer/blazegraph:2.1.1
docker logs -f blazegraph
```