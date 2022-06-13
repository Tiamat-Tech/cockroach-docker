# Secure CockroachDB Cluster with Flask, inspired by the [Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-use-a-postgresql-database-in-a-flask-application) tutorial.

Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `flask` - Flask container

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.


## The following step is no longer necessary, including composeexample as part of the repo. It can also be generated locally `django-admin startproject composeexample .`

1. because operation order is important, execute `./up.sh` instead of `docker compose up`
   - monitor the status of services via `docker-compose logs`
   - in case you need to adjust something in composexample/settings.py, you can
          use `docker-compose logs flask`, `docker-compose kill flask`, `docker-compose up -d flask`
          to debug and proceed.
4) visit the [CockroachDB UI](https://localhost:8080) and login with username `roach` and password `roach`
5) visit the [HAProxy UI](http://localhost:8081)
6) visit the [Flask](http://localhost:5000) webpage

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti roach-cert /bin/sh
docker exec -ti web /bin/bash
```

## If web container fails to start due to the following issue:

```bash
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/django/db/backends/base/base.py", line 219, in ensure_connection
    self.connect()
  File "/usr/local/lib/python3.7/site-packages/django/db/utils.py", line 90, in __exit__
    raise dj_exc_value.with_traceback(traceback) from exc_value
  File "/usr/local/lib/python3.7/site-packages/django/db/backends/base/base.py", line 219, in ensure_connection
    self.connect()
  File "/usr/local/lib/python3.7/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/django/db/backends/base/base.py", line 200, in connect
    self.connection = self.get_new_connection(conn_params)
  File "/usr/local/lib/python3.7/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/django/db/backends/postgresql/base.py", line 187, in get_new_connection
    connection = Database.connect(**conn_params)
  File "/usr/local/lib/python3.7/site-packages/psycopg2/__init__.py", line 127, in connect
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
django.db.utils.OperationalError: ERROR:  password authentication failed for user myprojectuser
```

Issue the following command to restart the container

```bash
docker-compose restart web
```

If you get the following error

```python
Traceback (most recent call last):
  File "/usr/local/lib/python3.9/threading.py", line 954, in _bootstrap_inner
    self.run()
  File "/usr/local/lib/python3.9/threading.py", line 892, in run
    self._target(*self._args, **self._kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/utils/autoreload.py", line 53, in wrapper
    fn(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/commands/runserver.py", line 121, in inner_run
    self.check_migrations()
  File "/usr/local/lib/python3.9/site-packages/django/core/management/base.py", line 459, in check_migrations
    executor = MigrationExecutor(connections[DEFAULT_DB_ALIAS])
  File "/usr/local/lib/python3.9/site-packages/django/db/migrations/executor.py", line 18, in __init__
    self.loader = MigrationLoader(self.connection)
  File "/usr/local/lib/python3.9/site-packages/django/db/migrations/loader.py", line 53, in __init__
    self.build_graph()
  File "/usr/local/lib/python3.9/site-packages/django/db/migrations/loader.py", line 216, in build_graph
    self.applied_migrations = recorder.applied_migrations()
  File "/usr/local/lib/python3.9/site-packages/django/db/migrations/recorder.py", line 77, in applied_migrations
    if self.has_table():
  File "/usr/local/lib/python3.9/site-packages/django/db/migrations/recorder.py", line 55, in has_table
    with self.connection.cursor() as cursor:
  File "/usr/local/lib/python3.9/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/base/base.py", line 259, in cursor
    return self._cursor()
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/base/base.py", line 235, in _cursor
    self.ensure_connection()
  File "/usr/local/lib/python3.9/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/base/base.py", line 219, in ensure_connection
    self.connect()
  File "/usr/local/lib/python3.9/site-packages/django/db/utils.py", line 90, in __exit__
    raise dj_exc_value.with_traceback(traceback) from exc_value
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/base/base.py", line 219, in ensure_connection
    self.connect()
  File "/usr/local/lib/python3.9/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/base/base.py", line 200, in connect
    self.connection = self.get_new_connection(conn_params)
  File "/usr/local/lib/python3.9/site-packages/django/utils/asyncio.py", line 26, in inner
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/django/db/backends/postgresql/base.py", line 187, in get_new_connection
    connection = Database.connect(**conn_params)
  File "/usr/local/lib/python3.9/site-packages/psycopg2/__init__.py", line 127, in connect
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
django.db.utils.OperationalError: server closed the connection unexpectedly
        This probably means the server terminated abnormally
        before or while processing the request.
```

restart the web container again


## Apply migration

```bash
docker-compose exec web python manage.py migrate
```

```bash
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying sessions.0001_initial... OK
```

## Additionally, to open the Django frontend and verify

Add the following to the `composeexample/settings.py`

```python
ALLOWED_HOSTS = ['127.0.0.1', 'localhost', '0.0.0.0']
```
and restart the container
