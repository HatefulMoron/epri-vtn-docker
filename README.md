# epri-vtn-docker

This repository contains a Dockerfile for building Epri's
OpenADR-Virtual-Top-Node[1], and a docker-compose file for starting it alongside
a postgres database.

To run:

```
$ git clone https://github.com/HatefulMoron/epri-vtn-docker
$ cd epri-vtn-docker
$ docker-compose up -d --build
```

.. then visit http://localhost:8080

[1]: https://github.com/epri-dev/OpenADR-Virtual-Top-Node
