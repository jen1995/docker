#!/usr/bin/env bash

sudo service ssh start
jupyter notebook --no-browser --ip 0.0.0.0 --NotebookApp.password='sha1:0c1ef741f8b0:883ed7c01cd402a1ca6d435b74222ac737cd1fe9'

# if [ -z "$@" ]; then
# 	exec bash
# else
# 	exec $@
# fi