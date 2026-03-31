#!/bin/bash
sg docker -c '
docker volume create voltest_final
docker run -d --name v_final -v voltest_final:/data ubuntu sleep infinity
docker exec v_final sh -c "echo \"vol_data_success\" > /data/test.txt"
docker rm -f v_final
docker run --rm -v voltest_final:/data ubuntu cat /data/test.txt
'
