function docker-reset -d "Stops all containers, removes those and all images altogether"
	set containters_run (docker ps -q)
	set containters_all (docker ps -a -q)
	set images_all (docker images -a -q)

	if test (count $containers_run) -gt 1
		docker stop $containters_run
	end

	if test (count $containers_all) -gt 1
		docker rm -f $containters_all
	end

	if test (count $images_all) -gt 1
    	docker rmi -f $images_all
    end
    
    docker system prune -f --volumes
end
