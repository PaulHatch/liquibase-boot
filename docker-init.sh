#!/bin/bash

if [ "$ROLLBACK" = "0" ]; then
    liquibase \
        --changeLogFile="changelog/changelog-root.yml" \
        --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        update
    
    if [ "$VERSION" != "NONE" ]; then
    liquibase \
        --changeLogFile="changelog/changelog-root.yml" \
        --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        tag $VERSION
    fi
else
    if ! [[ "$ROLLBACK" =~ ^[0-9]+$ ]]; then
        echo "Rolling back to ${ROLLBACK}"
        liquibase \
            --changeLogFile="changelog/changelog-root.yml" \
            --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
            --username="$DB_USER" \
            --password="$DB_PASSWORD" \
            rollback $ROLLBACK
    else
        echo "Rolling back ${ROLLBACK} change(s)"
        liquibase \
            --changeLogFile="changelog/changelog-root.yml" \
            --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
            --username="$DB_USER" \
            --password="$DB_PASSWORD" \
            rollbackCount $ROLLBACK
    fi
fi