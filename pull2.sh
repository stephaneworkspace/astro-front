#!/bin/sh
ssh debian@bressani.dev "cd /home/debian/www/astro-front && ./docker-build.sh && ./docker-run.sh"