begin
    set mongo 'mongo'
    set mongo_opts \
        -v $HOME/.local/var/mongo:/bitnami/mongodb/data/db:rw \
        -p 127.0.0.1:27017:27017/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e MONGODB_DISABLE_SYSTEM_LOG=true \
        -e MONGODB_ENABLE_DIRECTORY_PER_DB=true \
        # NOTE: looks like the "Failed to refresh key cache" error is still a thing
        # (see https://www.mongodb.com/community/forums/t/single-node-replicaset-never-finishing-instanciating-error-cannot-use-non-local-read-concern-until-replica-set-is-finished-initializing/164815)
        # -e MONGODB_REPLICA_SET_MODE=primary \
        ghcr.io/zcube/bitnami-compat/mongodb:6.0

    set postgres 'postgres'
    set postgres_opts \
        -v $HOME/.local/var/postgres:/bitnami/postgresql/data:rw \
        -p 127.0.0.1:5432:5432/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e POSTGRESQL_REPLICATION_MODE=master \
        bitnami/postgresql:16

    set redis 'redis'
    set redis_opts \
        -v $HOME/.local/var/redis:/bitnami/redis/data:rw \
        -p 127.0.0.1:6379:6379/tcp \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e REDIS_REPLICATION_MODE=master \
        bitnami/redis:7.2

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
            echo "Nothing to remove"
        end
    end

    function mongo_dump
        set -l opts (fish_opt -s p -l path --long-only --optional-val)
        set -a opts (fish_opt -s d -l db --long-only --optional-val)
        set -a opts (fish_opt -s c -l coll --long-only --optional-val)
        argparse --ignore-unknown $opts -- $argv
        or return

        if test -z "$_flag_path"
            set _flag_path "mongo-dump-$(date +%Y-%m-%d)"
        end

        set cmd_opts '--gzip' "--out=$_flag_path"

        if test -n "$_flag_db"
            set -a cmd_opts "--db=$_flag_db"
        end

        if test -n "$_flag_coll"
            set -a cmd_opts "--collection=$_flag_coll"
        end

        command mongodump $cmd_opts
    end

    function mongo_restore
        set -l opts (fish_opt -s p -l path --long-only --optional-val)
        set -a opts (fish_opt -s d -l db --long-only --optional-val)
        set -a opts (fish_opt -s c -l coll --long-only --optional-val)
        argparse --ignore-unknown $opts -- $argv
        or return

        if test -z "$_flag_path"
            set _flag_path .
        end

        set cmd_opts '--gzip'

        if test -n "$_flag_db"
            set -a cmd_opts "--db=$_flag_db"
        end

        if test -n "$_flag_coll"
            set -a cmd_opts "--collection=$_flag_coll"
        end

        command mongorestore $cmd_opts "$_flag_path"
    end

    function database -d 'Manages databases as containers (via Docker)'
        argparse --ignore-unknown --stop-nonopt -- $argv
        or return

        switch "$argv[1] $argv[2]"
            case 'up mongo' 'start mongo'
                up $mongo $mongo_opts
            case 'up postgres' 'start postgres'
                up $postgres $postgres_opts
            case 'up redis' 'start redis'
                up $redis $redis_opts
            case 'down mongo' 'stop mongo'
                down $mongo
            case 'down postgres' 'stop postgres'
                down $postgres
            case 'down redis' 'stop redis'
                down $redis
            case 'rm mongo' 'remove mongo'
                remove $mongo
            case 'rm postgres' 'remove postgres'
                remove $postgres
            case 'rm redis' 'remove redis'
                remove $redis
            case 'dump mongo'
                mongo_dump $argv[3..]
            case 'restore mongo'
                mongo_restore $argv[3..]
            case '*'
                echo 'Manage databases as containers (via Docker).'
                echo ''
                echo 'Usage:'
                echo "    $_ COMMAND DATABASE [OPTS...]"
                echo ''
                echo 'Commands:'
                echo '    up/start         Starts a new database container'
                echo '    down/stop        Stops an existing database container'
                echo '    rm/remove        Removes an existing database container'
                echo ''
                echo 'Mongo Commands:'
                echo '    dump             Exports the content of a running server'
                echo '    restore          Restores backups to a running server'
                echo ''
                echo 'Databases:'
                echo '    mongo            Specifies MongoDB as a database'
                echo '    postgres         Specifies Postgres as a database'
                echo '    redis            Specifies Redis as a database'
                echo ''
                echo 'Mongo Dump/Restore Options:'
                echo '    --path=<PATH>    Specifies a directory path or name'
                echo '                     [default: "mongo-dump-<DATE>" and "."]'
                echo '    --db=<NAME>      Specifies a database name'
                echo '    --coll=<NAME>    Specifies a collection name'
                echo ''
                echo 'Parameters:'
                echo '    COMMAND          A command name [required]'
                echo '    DATABASE         A database name [required]'
        end
    end
end
