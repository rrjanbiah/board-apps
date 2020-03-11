#!/bin/bash
#
# Install script for WordPress Hardening app setup
#
# Usage: ./wp_hardening.sh
#
{
	main() {
		if [[ $EUID -ne 0 ]];
		then
			echo "This script must be run as root"
			exit 1
		fi
		set -x
		whoami
		APP_DIR=$PWD
		echo "Giving Readable permission"
		chmod -R 0755 $APP_DIR
		POSTGRES_DBHOST=localhost
		POSTGRES_DBNAME=restyaboard
		POSTGRES_DBUSER=restya
		cd ../../../
		RESTYABOARD_DIR=$PWD
		# look for Non-empty sql dir 
		if [ "$(ls -A $APP_DIR/sql)" ]; then
			psql -U postgres -h  ${POSTGRES_DBHOST} -c "\q"
			error_code=$?
			if [ ${error_code} != 0 ]
			then
				echo "PostgreSQL Changing the permission failed with error code ${error_code} (PostgreSQL Changing the permission failed with error code 34)"
				return 34
			fi
			sleep 1
			echo "Importing SQL..."
			psql -h  ${POSTGRES_DBHOST} -d ${POSTGRES_DBNAME} -f "$APP_DIR/sql/r_wp_hardening.sql" -U ${POSTGRES_DBUSER}
			if [ ${error_code} != 0 ]
			then
				echo "PostgreSQL SQL importing failed with error code ${error_code} (PostgreSQL Empty SQL failed with error code 39)"
				return 39
			fi
		fi
		exit 1
    }
	main
	echo "If you're finding it difficult to setup WordPress Hardening app from your end, consider contacting Restya team at info@restya.com"
	exit 1
} 2>&1 | tee -a wp_hardening.log
