remove-old-images:
	docker rmi $$(docker images -qa -f 'dangling=true')
