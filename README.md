# build
docker --tls build -t bmedy/vif .

# verify
docker --tls run -t bmedy/vif java -version

# run
docker --tls run -d -p 80:8080 -t bmedy/vif