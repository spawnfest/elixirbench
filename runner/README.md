# Runner

This is an Elixir daemon that pulls for job our API and executes tests in `runner-container`.

## Sample YAML file

```
# bench/config.yml
elixir: 1.5.2
erlang: 20.1.2
environment:
  PG_URL: postgres:postgres@localhost
  MYSQL_URL: root@localhost
deps:
  docker:
    - image: postgres:alpine-latest
    - image: mysql:latest
```
