# Liquibase Example

This project provides a starting point for deploying Liquibase projects via a
Docker container to PostgreSQL. It includes:

- A Dockerfile which creates a container with Liquibase installed as well as the PostgreSQL driver and SnakeYAML to allow migrations to be written in YAML
- An init script to run inside the container which can apply or rollback changes
- An example migration
- A makefile to build and run the Docker image

The makefile can apply changes either to a specified host or a Postgres
instance running in a container by specifying the container name in the
`CONTAINER` environment variable, which will attempt to link to the
container named.

To rollback a previous change, call make with `ROLLBACK` set to either
a number of changes to rollback or a tag to roll back to. (Better tagging
support to be added.)

Additional environment variables include:

- DB_USER
- DB_PASSWORD
- DB_HOST
- DB_PORT
- DB_NAME
- VERSION
