#!/bin/bash
cd workspace
case $1 in
    up )
			docker-compose up -d 
			exit;;
    down )
			docker-compose down
			exit;;
    cli )           		
			docker-compose exec workspace /bin/sh
			exit;;
    server )
			docker-compose exec workspace /bin/sh -c "bee run --gendoc=true"
			exit;;
    test )
			docker-compose exec workspace /bin/sh -c "cd tests && go test -v"
			exit;;
	* )
		echo "up | down | cli | server | test"
		exit;;
esac