#!/bin/sh

set -e

echo psql | kinit tester@EXAMPLE.COM

env
echo "sleep 10"
sleep 10
python manage.py runserver 0.0.0.0:8000
#tail -f /dev/null
