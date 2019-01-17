#!/bin/bash
cd workspace
case $1 in
	get )
		empty=""
		URL=$2
		URL=${URL/https:\/\//$empty}
		URL=${URL/http:\/\//$empty}
		if [[ $URL == *"golang.org/x/"* ]]; then
			GITHUB_URL=${URL/golang\.org\/x\//$empty}
			PACKAGE_NAME=`echo $GITHUB_URL | cut -d "/" -f 1`
			CMD="git submodule add https://github.com/golang/$PACKAGE_NAME ./vendor/golang.org/x/$PACKAGE_NAME"
		else
			URL=`echo $URL | cut -d "/" -f 1`/`echo $URL | cut -d "/" -f 2`/`echo $URL | cut -d "/" -f 3`
			CMD="git submodule add https://$URL ./vendor/$URL"
		fi
		echo $CMD
		# exit;
		cd .. && $CMD	
		exit;;
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