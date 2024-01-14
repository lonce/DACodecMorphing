# Fork of the Descript RQVGAN (see their README in this repository)

1) If you don't already have access to a container built from this repository (lonce:dacdevupf in S'pore, or the /home/lonce/descript/lwyse_foo.sif on the HPC cluster in BCN), then you can build a docker container. 
To build the docker container:
```
docker image build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --file Dockerfile --tag yourname:containername  .
```

2) uncompress dacdevdata.zip (where datafiles used in the notebooks are stored). The notebooks get their audio files from the folder that is created.

To run this docker thus:
```
docker run --ipc=host --gpus "all" -it -v /fullpath-to-local-dir:/app --name foo --rm yourname:containername
```
>  
    where
        /full-path-to-local-dir   - is the absolute path to the folder where this repository lives (/app is necessary because that's how it is referenced in the notebooks)
       foo   - is whatever name you want to give to the running docker container
        (the -v a:b flag maps a full path 'a' to a path you can use in the docker, 'b').

   The only thing left to do is run jupyter inside the docker and then point a browser to the running notebook. You might have your own way of doing this, but because I am running remotely, I do it this way:

   Inside the docker I run jupyter notebooks:
user> jupyter lab --no-browser --port=8889 --ip=0.0.0.0  &
 to run jupyter in the background, then
user> ^P ^Q
  to "detach" from the docker while leaving the container running ( 'docker attach foo' will put you back in the container)

> docker inspect foo
       to find the IPAddress that the container is using

Now you need an ssh tunnel from you local machine to the IP and port that jupyter is running on.  Let's say the docker is using
172.17.0.5:8889  (we specified the port when we ran jupyter), then you need a tunnel from some local port (for example 7775) to 172.17.0.5:8889.
Once you have the tunnel set up, you can point your browser to:
localhost:7775, and whalah, you can open the notebooks and run them.

If you don't want to wait for the Descript pre-trained models to download every time (see the top of any of the notebooks), you can download the models and load them locally and point the model_path to the file. To download them, run wget at a commandline prompt:  

wget https://github.com/descriptinc/descript-audio-codec/releases/download/0.0.5/weights_16khz.pth  
see dac/utils/__init__.py for other models using other sample rates.
