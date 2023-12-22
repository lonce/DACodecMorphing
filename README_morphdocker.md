# Fork of the Descript RQVGAN (see their README in this repository)

First, 
To build the docker:
```
docker image build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --file MyUPFDockerfile.dev --tag yourname:containername  .
```

Uncompress dacdevdata.zip (where datafiles used in the notebooks are stored)

Run this docker thus:
```
docker run --ipc=host --gpus "all" -it -v full-path-to-parent-of-dacdevdata-dir:/scratch -v /fullpath-to-local-dir:/apps --name foo --rm yourname:containername
```
>  
    where
        /full-path-to-notebooks   - is the absolute path to the unzipped notebooks folder
       foo   - is whatever name you want to give to the running docker container
       The other parts of the command should not be changed (/scratch is where I have put sounds referenced in the notebooks, /app is where the working directory created by the docker and is also used by the notebooks)
        (the -v a:b flag maps a full path 'a' to a path you can use in the docker, 'b').

   The only thing left to do is run jupyter inside the docker and then point a browser to the running notebook. You might have your own way of doing this, but because I am running remotely, I do it this way:

   Inside the docker I run jupyter notebooks:
user> jupyter lab --no-browser --port=8889 --ip=0.0.0.0  &
 to run jupyter in the background, then
user> ^P ^Q
  to "detach" from the docker while leaving the container running ( 'docker attach foo' will put you back in the container)

> docker inspect foo
       to find the IPAddress container is using

Now you need an ssh tunnel from you local machine to the IP and port that jupyter is running on.  Let's say the docker is using
172.17.0.5:8889  (we specified the port when we ran jupyter), then you need a tunnel from some local port (for example 7777) to 172.17.0.5:8889.
Once you have the tunnel set up, you can point your browser to:
localhost:7777, and whalah, you can open the notebooks and run them.