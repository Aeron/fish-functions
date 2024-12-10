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
        # -e MONGODB_REPLICA_SET_MODE=primary

    set postgres_image 'bitnami/postgresql:16'
    set postgres_opts \
        -v $HOME/.local/var/postgres:/bitnami/postgresql/data:rw \
        -p 127.0.0.1:5432:5432/tcp \
        -p 127.0.0.1:5434:5432/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e POSTGRESQL_REPLICATION_MODE=master

    set valkey_image 'bitnami/valkey:8.0'
    set valkey_opts \
        -v $HOME/.local/var/valkey:/bitnami/valkey/data:rw \
        -p 127.0.0.1:6379:6379/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e VALKEY_REPLICATION_MODE=primary

    set redis_image 'bitnami/redis:7.4'
    set redis_opts \
        -v $HOME/.local/var/redis:/bitnami/redis/data:rw \
        -p 127.0.0.1:6379:6379/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e REDIS_REPLICATION_MODE=master

    set dragonfly_image 'docker.dragonflydb.io/dragonflydb/dragonfly:latest'
    set dragonfly_opts \
        -v $HOME/.local/var/dragonfly:/data:rw \
        -p 127.0.0.1:6379:6379 \
        --ulimit memlock=-1

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
            case 'up redis' 'start redis'
                up redis $redis_image $redis_opts
            case 'up valkey' 'start valkey'
                up valkey $valkey_image $valkey_opts
            case 'up dragonfly' 'start dragonfly'
                up dragonfly $dragonfly_image $dragonfly_opts
            case 'down mongo' 'stop mongo'
                down mongo
            case 'down postgres' 'stop postgres'
                down postgres
            case 'down redis' 'stop redis'
                down redis
            case 'down valkey' 'stop valkey'
                down valkey
            case 'down dragonfly' 'stop dragonfly'
                down dragonfly
            case 'rm mongo' 'remove mongo'
                remove mongo
            case 'rm postgres' 'remove postgres'
                remove postgres
            case 'rm redis' 'remove redis'
                remove redis
            case 'rm valkey' 'remove valkey'
                remove valkey
            case 'rm dragonfly' 'remove dragonfly'
                remove dragonfly
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
                echo '  valkey         Specifies Valkey as a database'
                echo '  redis          Specifies Redis as a database'
                echo '  dragonfly      Specifies Dragonfly as a database'
                echo ''
                echo 'Parameters:'
                echo '  COMMAND        A command name [required]'
                echo '  DATABASE       A database name [required]'
        end
    end
end
