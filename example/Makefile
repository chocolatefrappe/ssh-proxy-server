docker_stack_name := ssh_server

deploy:
	docker stack deploy -c docker-compose.yml $(docker_stack_name)

teardown:
	docker stack rm $(docker_stack_name)
