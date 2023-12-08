begin
    set mongo 'mongo'
    set mongo_opts \
        -v /usr/local/var/mongodb:/bitnami/mongodb/data/db:rw \
        -p 127.0.0.1:27017:27017/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e MONGODB_DISABLE_SYSTEM_LOG=true \
        -e MONGODB_ENABLE_DIRECTORY_PER_DB=true \
        -e MONGODB_REPLICA_SET_MODE=primary \
        ghcr.io/zcube/bitnami-compat/mongodb:6.0

    set postgres 'postgres'
    set postgres_opts \
        -v /usr/local/var/postgres:/var/lib/postgresql/data:rw \
        -p 127.0.0.1:5432:5432/tcp \
        -e POSTGRES_HOST_AUTH_METHOD=trust \
        postgres:14-alpine

    function up -a name
        if test ! (docker ps -aq --filter name=$name)
            docker run --detach --restart=unless-stopped --name=$name $argv[2..]
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
            echo "Already removed"
        end
    end

    function database -a cmd db -d 'Manages databases as containers (via Docker)'
        switch "$cmd $db"
            case 'up mongo' 'start mongo'
                up $mongo $mongo_opts
            case 'up postgres' 'start postgres'
                up $postgres $postgres_opts
            case 'down mongo' 'stop mongo'
                down $mongo
            case 'down postgres' 'stop postgres'
                down $postgres
            case 'rm mongo' 'remove mongo'
                remove $mongo
            case 'rm postgres' 'remove postgres'
                remove $postgres
            case '*'
                echo "$_ manage databases as containers (via Docker)."
                echo ''
                echo 'Usage:'
                echo "    $_ COMMAND DATABASE"
                echo ''
                echo 'Commands:'
                echo '    up/start     Starts a new database container'
                echo '    down/stop    Stops an existing database container'
                echo '    rm/remove    Removes an existing database container'
                echo ''
                echo 'Databases:'
                echo '    mongo        Specifies MongoDB as a database'
                echo '    postgres     Specifies Postgres as a database'
                echo ''
                echo 'Parameters:'
                echo '    COMMAND      A command name [required]'
                echo '    DATABASE     A database name [required]'
        end
    end
end
