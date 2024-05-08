begin
    set mongo_image 'ghcr.io/zcube/bitnami-compat/mongodb:6.0'
    set mongo_opts \
        -v $HOME/.local/var/mongo:/bitnami/mongodb/data/db:rw \
        -p 127.0.0.1:27017:27017/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e MONGODB_DISABLE_SYSTEM_LOG=true \
        -e MONGODB_ENABLE_DIRECTORY_PER_DB=true
        # NOTE: looks like the "Failed to refresh key cache" error is still a thing
        # (see https://www.mongodb.com/community/forums/t/single-node-replicaset-never-finishing-instanciating-error-cannot-use-non-local-read-concern-until-replica-set-is-finished-initializing/164815)
        # -e MONGODB_REPLICA_SET_MODE=primary \

    set postgres_image 'bitnami/postgresql:16'
    set postgres_opts \
        -v $HOME/.local/var/postgres:/bitnami/postgresql/data:rw \
        -p 127.0.0.1:5432:5432/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e POSTGRESQL_REPLICATION_MODE=master

    set valkey_image 'bitnami/valkey:7.2'
    set valkey_opts \
        -v $HOME/.local/var/valkey:/bitnami/valkey/data:rw \
        -p 127.0.0.1:6379:6379/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e VALKEY_REPLICATION_MODE=master

    function up -a name image
        if test ! (docker ps -aq --filter name=$name)
            docker pull $image
            docker run --detach --restart=unless-stopped --name=$name $argv[3..] $image
        else if test ! (docker ps -q --filter name=$name)
            docker start $name
        else
            echo "Already running"
        end
    end

    function down -a name
        if test (docker ps -q --filter name=$name)
            docker stop $name
        else
            echo "Already stopped"
        end
    end

    function remove -a name
        if test (docker ps -aq --filter name=$name)
            docker rm -f $name
        else
            echo "Nothing to remove"
        end
    end

    function database -d 'Manages databases as containers (via Docker)'
        argparse --ignore-unknown --stop-nonopt -- $argv
        or return

        switch "$argv[1] $argv[2]"
            case 'up mongo' 'start mongo'
                up mongo $mongo_image $mongo_opts
            case 'up postgres' 'start postgres'
                up postgres $postgres_image $postgres_opts
            case 'up redis' 'start redis' 'up valkey' 'start valkey'
                up valkey $valkey_image $valkey_opts
            case 'down mongo' 'stop mongo'
                down mongo
            case 'down postgres' 'stop postgres'
                down postgres
            case 'down redis' 'stop redis' 'down valkey' 'stop valkey'
                down valkey
            case 'rm mongo' 'remove mongo'
                remove mongo
            case 'rm postgres' 'remove postgres'
                remove postgres
            case 'rm redis' 'remove redis' 'rm valkey' 'remove redis'
                remove valkey
            case '*'
                echo 'Manage databases as containers (via Docker).'
                echo ''
                echo "Usage: $_ COMMAND DATABASE"
                echo ''
                echo 'Commands:'
                echo '  up/start       Starts a new database container'
                echo '  down/stop      Stops an existing database container'
                echo '  rm/remove      Removes an existing database container'
                echo ''
                echo 'Databases:'
                echo '  mongo          Specifies MongoDB as a database'
                echo '  postgres       Specifies Postgres as a database'
                echo '  valkey, redis  Specifies Valkey as a database'
                echo ''
                echo 'Parameters:'
                echo '  COMMAND        A command name [required]'
                echo '  DATABASE       A database name [required]'
        end
    end
end
