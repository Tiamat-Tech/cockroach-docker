# Secure CockroachDB Cluster, inspired by [Docker tutorial](https://docs.docker.com/compose/django/)
Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1) `docker-compose run web django-admin startproject composeexample .`

```bash
14:32 $ docker-compose run web django-admin startproject composeexample .
Starting roach-cert ... done
Starting roach-0    ... done
```

3) because operation order is important, execute `./up.sh` instead of `docker-compose up`
   - monitor the status of services via `docker-compose logs`
   - in case you need to adjust something in composexample/settings.py, you can
          use `docker-compose logs web`, `docker-compose kill web`, `docker-compose up -d web`
          to debug and proceed.
4) visit the CockroachDB [Admin UI](https://localhost:8080) and login with username `test` and password `password`
5) visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh

# shell
docker exec -ti roach-cert /bin/sh

# cli inside the container
cockroach sql --certs-dir=/certs --host=roach-0

# directly
docker exec -ti roach-0 cockroach sql --certs-dir=/certs --host=roach-0
```

6) Connect to `cockroach` using `psql`

```bash
docker exec -it psql bash
psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
root@psql:/# psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
psql (9.5.22, server 9.5.0)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```

7) Connect to `cockroach` using `psql` and `krbsrvname`

```bash
docker exec -it psql bash
psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```
