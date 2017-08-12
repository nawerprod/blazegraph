
# Supported tags and respective `Dockerfile` links

-	[`2.1.5`, `2.1`, `2`, `latest` (*2.1.5/Dockerfile*)](https://github.com/docker-library/mysql/blob/e207dbbdfd5c95e4b51bdc2dae62c5f72a1dd908/8.0/Dockerfile)
-	[`2.1.4` (*2.1.4/Dockerfile*)](https://github.com/docker-library/mysql/blob/0590e4efd2b31ec794383f084d419dea9bc752c4/5.7/Dockerfile)
-	[`2.1.2` (*2.1.2/Dockerfile*)](https://github.com/docker-library/mysql/blob/7ee927986b8c0cbfa6cdbb073a0e662bdb62c18a/5.6/Dockerfile)
-	[`2.1.1` (*2.1.1/Dockerfile*)](https://github.com/docker-library/mysql/blob/08b08d88066bc27f82212631e1d3415b61097afe/5.5/Dockerfile)
-	[`2.1.0` (*2.1.0/Dockerfile*)](https://github.com/docker-library/mysql/blob/08b08d88066bc27f82212631e1d3415b61097afe/5.5/Dockerfile)
-	[`2.0.1` (*2.0.1/Dockerfile*)](https://github.com/docker-library/mysql/blob/08b08d88066bc27f82212631e1d3415b61097afe/5.5/Dockerfile)
-	[`2.0.0` (*2.0.0/Dockerfile*)](https://github.com/docker-library/mysql/blob/08b08d88066bc27f82212631e1d3415b61097afe/5.5/Dockerfile)

# What is Blazegraph?

Blazegraph is ultra-scalable, high-performance graph database with support for the Blueprints and RDF/SPARQL APIs. See our Single Server and Embedded version.

For more information and related downloads for Blazegraph Server, please visit [www.blazegraph.com](http://www.blazegraph.com).

![logo](https://raw.githubusercontent.com/docker-library/docs/c408469abbac35ad1e4a50a6618836420eb9502e/mysql/logo.png)

# How to use this image

## Start a `blazegraph` server instance

Starting a Blazegraph instance is simple:

```console
$ docker run --name some-blazegraph -d nawer/blazegraph:tag
```

... where `some-blazegraph` is the name you want to assign to your container, `tag` is the tag specifying the Blazegraph version you want. See the list above for relevant tags.

## Connect to Blazegraph from an application in another Docker container

This image exposes the standard Blazegraph port (9999), so container linking makes the Blazegraph instance available to other application containers. Start your application container like this in order to link it to the Blazegraph container:

```console
$ docker run --name some-app --link some-blazegraph:blazegraph -d application-that-uses-blazegraph
```

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `mysql`:

```yaml
version: '3.1'

services:

    db:
        image: nawer/blazegraph
        environment:
            JAVA_XMS: 512m
            JAVA_XMX: 1g

```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/docker-library/docs/96c08fac215f64844b9db61038a571b86534a12b/mysql/stack.yml)

Run `docker stack deploy -c stack.yml mysql` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:9999`, `http://localhost:9999`, or `http://host-ip:9999` (as appropriate).

## Container shell access and viewing Blazegraph logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `blazegraph` container:

```console
$ docker exec -it some-blazegraph bash
```

The Blazegraph Server log is available through Docker's container log:

```console
$ docker logs some-blazegraph
```

## Using a custom Blazegraph configuration file

The Blazegraph startup configuration is specified in the file `/etc/blazegraph/override.xml`. Settings in this file will augment and/or override default settings of `blazegraph`. If you want to use a customized Blazegraph configuration, you can create your alternative configuration file in a directory on the host machine and then mount that directory location as `/etc/blazegraph/override.xml` inside the `blazegraph` container.

If `/my/custom/override.xml` is the path and name of your custom configuration file, you can start your `blazegraph` container like this :

```console
$ docker run --name some-blazegraph -v /my/custom/override.xml:/etc/blazegraph/override.xml -d blazegraph:tag
```

## Environment Variables

When you start the `blazegraph` image, you can adjust the configuration of the Blazegraph instance by passing one or more environment variables on the `docker run` command line. Do note that none of the variables below will have any effect if you start the container with a data directory that already contains a database: any pre-existing database will always be left untouched on container startup.

### `JAVA_XMS`

This variable is optional and allows you to specify specifies the initial memory allocation pool for the Java Virtual Machine (JVM). Default is set to 512Mio.

### `JAVA_XMX`

This variable is optional and allows you to specify the maximum memory allocation pool for the Java Virtual Machine (JVM). Default is set to 1Gio.

# Initializing a fresh instance

When a container is started for the first time, a new `kb` namespace will be created and initialized with the provided configuration variables.
Furthermore, it will load RWStore.properties found in `/docker-entrypoint-initdb.d/someNamespace` to configure the namespace and import RDF files
present in `/docker-entrypoint-initdb.d/someNamespace/data/`  . Files will be executed in alphabetical order.

# Credits for this readme

A huge part of this readme is largely inspired by [mysql docker readme](https://hub.docker.com/_/mysql/)