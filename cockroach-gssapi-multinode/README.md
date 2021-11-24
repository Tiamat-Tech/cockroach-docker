# A Secure CockroachDB Cluster with Kerberos and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with Django and MIT Kerberos](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
- Part 8: [CockroachDB with SQLAlchemy and MIT Kerberos](https://blog.ervits.com/2020/08/cockroachdb-with-sqlalchemy-and-mit.html)
- Part 9: [CockroachDB with MIT Kerberos using a native client](https://blog.ervits.com/2020/10/cockroachdb-with-mit-kerberos-using.html)
- Part 10: [CockroachDB with MIT Kerberos along with cert user authentication](https://blog.ervits.com/2021/06/cockroachdb-with-mit-kerberos-along.html)
- Part 11: [CockroachDB with GSSAPI deployed via systemd](https://blog.ervits.com/2021/07/cockroachdb-with-gssapi-deployed-via.html)
- Part 12: [Selecting proper cipher for CockroachDB with GSSAPI](https://blog.ervits.com/2021/07/selecting-proper-encryption-type-for.html)
- Part 13: [Overriding KRB5CCNAME for CockroachDB with GSSAPI](https://blog.ervits.com/2021/07/cockroachdb-with-gssapi-overriding.html)

---

## Services

* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `client` - cockroach client node, also has `psql` installed

## Getting started

>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

### Open Interactive Shells

```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash
docker exec -ti kdc sh

docker exec -ti client cockroach sql --certs-dir=/certs --host=lb
```

1) execute `./up.sh` instead of `docker compose up`
   - monitor the status of services via `docker compose logs`
2) visit the [DB Console](http://localhost:8080)
3) visit the [HAProxy UI](http://localhost:8081)

4) Connecting to CockroachDB using the native binary

```bash
docker exec -it client \
cockroach sql --certs-dir=/certs --host=lb.local --user=tester
```

```bash
#
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
# Server version: CockroachDB CCL v21.2.0 (x86_64-unknown-linux-gnu, built 2021/11/15 13:58:04, go1.16.6) (same version as client)
# Cluster ID: 71429258-dbc1-4fda-afb8-7a2d4920681c
# Organization: Cockroach Labs - Production Testing
#
# Enter \? for a brief introduction.
#
tester@lb.local:26257/defaultdb> 
```

5) Connecting with native client and `--url` flag

```bash
docker exec -it client cockroach sql \
 --certs-dir=/certs --url  "postgresql://tester:nopassword@lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn"
```

6) Connect to `cockroach` using `psql`

__NOTE__: Directly connecting to `psql` from host fails

```bash
docker exec -it client psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```bash
psql: error: connection to server at "lb" (172.28.0.6), port 26257 failed: connection to server at "lb" (172.28.0.6), port 26257 failed: ERROR:  unimplemented: unimplemented client encoding: "sqlascii"
HINT:  You have attempted to use a feature that is not yet implemented.
See: https://go.crdb.dev/issue-v/35882/v21.2
```

Shelling into the container

```bash
docker exec -it client bash
```

```bash
psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
psql (14.1, server 13.0.0)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_128_GCM_SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=> 
```

using native binary

```bash
./cockroach sql --host=lb.local --certs-dir=/certs --user tester
```

7) Connect to `cockroach` using `psql` and `krbsrvname`

```bash
psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```

8) Connect to Cockroach using `psql` with parameters

```bash
 psql "host=lb port=26257 dbname=defaultdb user=tester"
```

or

```bash
 psql "host=lb.local port=26257 dbname=defaultdb user=tester"
```

