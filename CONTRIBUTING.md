# CONTRIBUTING

In order to contribute to this ontology, please follow the steps below.

## Instructions

To contribute you'll need to follow the [Angular commit message convention](https://gist.github.com/stephenparish/9941e89d80e2bc58a153).

_Process_:
1. Fork our develop branch
2. Create a branch describing your contribution for instance: `git checkout -b feat/updateAttributes`
3. Be sure to join a visualization of your ontology.
4. Summit your work as a pull request.

## Docker deployment

### Introduction

You can find the full tutorial [there](https://hub.docker.com/r/stain/jena-fuseki/)
### Install the image

It will download the lastest image of `stain/jena-fuseki`
```
✗ docker build -t storeconnect/sensor-ontology .
Sending build context to Docker daemon 570.4 kB
Step 1 : FROM stain/jena-fuseki:latest
latest: Pulling from stain/jena-fuseki
b7f33cc0b48e: Already exists 
49eda009e7d0: Pull complete 
...
Digest: sha256:2fc39fc1d52e49f390381eed43944cb2bf70d26f75180877bfb47e65fa81cd0b
Status: Downloaded newer image for stain/jena-fuseki:latest
 ---> d28cf30604b8
Successfully built d28cf30604b8
```

If successful, you should be able to see `storeconnect/sensor-ontology`
```
✗ docker images        
REPOSITORY                     TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
storeconnect/sensor-ontology   latest              d28cf30604b8        3 weeks ago         142.9 MB
```

Be sure to have a recent version of docker-compose
```
✗ docker-compose -v
docker-compose version 1.10.0, build 4bd6f1a
```

Or update it
```
✗ curl -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
✗ chmod +x /usr/local/bin/docker-compose

```

We also need a container to persist data.
```
✗ docker run --name fuseki-data -v /fuseki busybox
```

Next we need to create our fuseki container.
```
✗ sudo docker run --name fuseki -d -p 3030:3030 --volumes-from fuseki-data storeconnect/sensor-ontology
```

Before going any further check your admin password running the following command. You will need it to administrate your database.
```
✗ docker logs fuseki                                                                                   
###################################
Initializing Apache Jena Fuseki

Randomly generated admin password:

admin=youradminpassword

###################################
```

You'll next need to create your database, you can do so through the web interface at `http://localhost:3030` and create a database named `yourDatabaseName`
Be sure to select `Persistent – dataset will persist across Fuseki restarts`

Load our ontology into it. This will update `fuseki-data` and delete the temporary container.
```
✗ sudo docker run --rm --volumes-from fuseki-data -v /Users/spirals/Documents/Work/Git/sensors-ontology/data/sensorsDB:/staging storeconnect/sensor-ontology ./load.sh yourDatabaseName
```

Finally `restart` our container:
```
✗ docker restart fuseki
```

At this point you should be able to query the ontology.

Those are the two containers you should have.
```
✗ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                      PORTS               NAMES
14eafbd113d8        storeconnect/sensor-ontology   "/docker-entrypoint.s"   30 seconds ago      Exited (0) 26 seconds ago                       fuseki
15d7fe9e8370        busybox                        "sh"                     17 hours ago        Exited (0) 17 hours ago                         fuseki-data
```