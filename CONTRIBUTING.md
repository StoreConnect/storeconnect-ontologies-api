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
Sending build context to Docker daemon 610.3 kB
Step 1/1 : FROM stain/jena-fuseki:latest
 ---> d28cf30604b8
Successfully built d28cf30604b8
```

If successful, you should be able to see `storeconnect/sensor-ontology`
```
✗ docker images 
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
storeconnect/sensor-ontology   latest              d28cf30604b8        3 weeks ago         143 MB
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

Next we need to create our fuseki container and bind it to its persistance volume location.
```
✗ sudo docker run -d --name fuseki -p 3030:3030 -v /path/to/sensors-ontology/data:/fuseki storeconnect/sensor-ontology
```

Before going any further check your admin password running the following command. You will need it to administrate your database.
You can find it in the `data/shiro.ini` file.
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

Load our ontology into it. This command will load every .owl within the src/ folder.
```
✗ sudo docker run --rm --volumes-from fuseki -v /path/to/sensors-ontology/src:/staging storeconnect/sensor-ontology ./load.sh yourDatabaseName      
```

Finally `restart` our container:
```
✗ docker restart fuseki
```

At this point you should be able to query the ontology.