#!/bin/sh
ssh debian@astrologie-traditionnelle.net "cd /home/debian/www/astro-front/ && git pull && docker stop docker-vue-js-app-2"