# Fork of the Descript RQVGAN (see their README in this repository)

1) If you don't already have access to a container built from this repository (lonce:dacdevupf in S'pore, or the /home/lwyse/working/DACodecMorphing/lwyse_dacdevupf23.sif on the HPC cluster in BCN), then you can build the container yourself. 
To build the docker container:
```
docker image build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --file Dockerfile --tag yourname:containername  .
```

2) uncompress dacdevdata.zip (where datafiles used in the notebooks are stored). The notebooks get their audio files from the folder that is created.

3) Run your container: 
To run this docker thus:
```
docker run --ipc=host --gpus "all" -it -v /fullpath-to-local-dir:/app --name foo --rm yourname:containername
```
>  
    where
        /full-path-to-local-dir   - is the absolute path to the folder where this repository lives (/app is necessary because that's how it is referenced in the notebooks)
       foo   - is whatever name you want to give to the running docker container
        (the -v a:b flag maps a full path 'a' to a path you can use in the docker, 'b').

If you are running on the HPC in BCN:

Start an interactive session (interactive -g 1), 

While you are in an interactive session on a research compute note, get the docker from the UPF repository (which automatically builds to a Singularity container): 
```
singularity pull --docker-login docker://registry.sb.upf.edu/mtg/lwyse:dacdev23
```
Go get a cup of coffee. 

Then run the container, 
```
singularity run --nv  --bind $(pwd):/app lwyse_dacdevupf23.sif
```


4) Run jupyter inside your container and then point a browser to the running notebook (using an ssh tunnel as explained below). You might have your own way of doing this, but because I am running remotely, I do it this way:

   Run jupyter notebooks in the background:
```
jupyter lab --no-browser --port=8889 --ip=0.0.0.0 &
```
 
5) Point your local browser to 
```
localhost:xxxx
```
where xxxx is the local port number you are using for the ssh tunnel to the remote machine and port number. 

If you are running a docker container, check the remote machine ip addresss this way: 

user> ^P ^Q
  to "detach" from the docker while leaving the container running ( 'docker attach foo' will put you back in the container)

> docker inspect foo
       to find the IPAddress that the container is using


You need an ssh tunnel from you local machine to the IP and port that jupyter is running on.  Let's say the docker is using
172.17.0.5:8889  (we specified the port when we ran jupyter), then you need a tunnel from some local port (for example 7775) to 172.17.0.5:8889.
Once you have the tunnel set up, you can point your browser to:
localhost:7775, and whalah, you can open the notebooks and run them.

If you are running on HPC research nodes (eg node022) the remote end of the ssh tunnel would look like node002:8889 where 8889 was specified when you ran jupyter. Your local port number for the tunnel is whatever you set it to.

6)
If you don't want to wait for the Descript pre-trained models to download every time (see the top of any of the notebooks), you can download the models and load them locally and point the model_path to the file. To download them, run wget at a commandline prompt:  

wget https://github.com/descriptinc/descript-audio-codec/releases/download/0.0.5/weights_16khz.pth  
see dac/utils/__init__.py for other models using other sample rates.
