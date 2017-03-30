#!/bin/bash
#######################
### add static site ###
#######################


# start site attach
read -p "Add site $1 ? [yN]" answer
if [[ $answer = y ]] ; then

	# mkdir for site
	mkdir -p /sites/$1

	# site permission
	chown www-data:www-data /sites/$1
	chmod 775 /sites/$1

	# write config
	cat example.com > /etc/nginx/sites-enabled/$1
	# now i move from sites-enabled to sites-availible for disable site

	sed -i "s/example.com/$1/g" /etc/nginx/sites-enabled/$1
	service nginx reload

	read -p "Issue https? [yN]" https
	if [[ $https = y ]] ; then

		#rewrite config to ssl support
		cat ssl-example.com > /etc/nginx/sites-enabled/$1
		sed -i "s/example.com/$1/g" /etc/nginx/sites-enabled/$1

		# issue https cert
		/root/.acme.sh/acme.sh --issue -d $1 -w /sites/$1;

		# and install https cert
		/root/.acme.sh/acme.sh --installcert -d $1 --keypath /etc/nginx/ssl/$1.key --capath /etc/nginx/ssl/$1.ca --fullchainpath /etc/nginx/ssl/$1.crt --reloadcmd "service nginx reload";
	fi

# end site attachment
fi


