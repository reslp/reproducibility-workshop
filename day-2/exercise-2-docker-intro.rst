.. role:: bash(code)
   :language: bash

================================
Exercise 2 - Working with Docker
================================

A successful Docker installation runs in the background out of sight of the user. At its core is the so-called Docker deamon (or ``dockerd``) which manages different docker objects such as containers, images or volumes.
The way to interact with the Docker daemon and tell it what to do is through a command line interface (CLI) program which is called :bash:`docker`. We refer to this here as the :bash:`docker` command. 
The docker command is very powerful and it allows us to change many aspects of how Docker runs containers, manages images or creates volumes. In this exercise, we will be introducing the :bash:`docker` command and show how to run and interact with Docker images.

Definitions
===========

Several terms will come up regularly during the live coding-sessions and in this document. Therefore we have summarized them here again:

- Docker image: A read only file which contains all the code, library, dependencies etc. for an application to run. They are basically templates of the software and are the basis of Docker containers.
- Docker container: A container is a writeable copy of an image inside an enclosed environment. When an image lives inside a container it can be modified and the container can be executed.

First steps with the docker command
===================================

You can test your Docker installation by executing the following command, which will print the version of the installed Docker engine:

.. code-block:: bash

    (host) $ docker -v
    Docker version 19.03.8, build afacb8b

To get an idea what we can do with docker you can run the docker command without any flag:

.. code-block:: bash

    (host) $ docker
    
    Usage:	docker [OPTIONS] COMMAND
    
    A self-sufficient runtime for containers
    
    Options:
          --config string      Location of client config files (default "/Users/sinnafoch/.docker")
      -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")
      -D, --debug              Enable debug mode
      -H, --host list          Daemon socket(s) to connect to
      -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
          --tls                Use TLS; implied by --tlsverify
          --tlscacert string   Trust certs signed only by this CA (default "/Users/sinnafoch/.docker/ca.pem")
          --tlscert string     Path to TLS certificate file (default "/Users/sinnafoch/.docker/cert.pem")
          --tlskey string      Path to TLS key file (default "/Users/sinnafoch/.docker/key.pem")
          --tlsverify          Use TLS and verify the remote
      -v, --version            Print version information and quit
    
    Management Commands:
      builder     Manage builds
      checkpoint  Manage checkpoints
      config      Manage Docker configs
      container   Manage containers
      context     Manage contexts
      image       Manage images
      network     Manage networks
      node        Manage Swarm nodes
      plugin      Manage plugins
      secret      Manage Docker secrets
      service     Manage services
      stack       Manage Docker stacks
      swarm       Manage Swarm
      system      Manage Docker
      trust       Manage trust on Docker images
      volume      Manage volumes
    
    Commands:
      attach      Attach local standard input, output, and error streams to a running container
      build       Build an image from a Dockerfile
      commit      Create a new image from a container's changes
      cp          Copy files/folders between a container and the local filesystem
      create      Create a new container
      deploy      Deploy a new stack or update an existing stack
      diff        Inspect changes to files or directories on a container's filesystem
      events      Get real time events from the server
      exec        Run a command in a running container
      export      Export a container's filesystem as a tar archive
      history     Show the history of an image
      images      List images
      import      Import the contents from a tarball to create a filesystem image
      info        Display system-wide information
      inspect     Return low-level information on Docker objects
      kill        Kill one or more running containers
      load        Load an image from a tar archive or STDIN
      login       Log in to a Docker registry
      logout      Log out from a Docker registry
      logs        Fetch the logs of a container
      pause       Pause all processes within one or more containers
      port        List port mappings or a specific mapping for the container
      ps          List containers
      pull        Pull an image or a repository from a registry
      push        Push an image or a repository to a registry
      rename      Rename a container
      restart     Restart one or more containers
      rm          Remove one or more containers
      rmi         Remove one or more images
      run         Run a command in a new container
      save        Save one or more images to a tar archive (streamed to STDOUT by default)
      search      Search the Docker Hub for images
      start       Start one or more stopped containers
      stats       Display a live stream of container(s) resource usage statistics
      stop        Stop one or more running containers
      tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
      top         Display the running processes of a container
      unpause     Unpause all processes within one or more containers
      update      Update configuration of one or more containers
      version     Show the Docker version information
      wait        Block until one or more containers stop, then print their exit codes
    
    Run 'docker COMMAND --help' for more information on a command.


This may look overwhelming at first but it illustrates that Docker is capable of many different things and there are many different ways how to do them. Also, during your daily docker use, you may actually only need a subset of what is listed above. Because Docker can do so many different things the :bash:`docker` command is organized in sub-commands which correspond to different aspects of Docker. Docker sub-commands can be further customized with traditional command-line flags.

.. hint:: 

        **Getting help**

	If you would like to know about the different options you can use the docker command like so to display additional help: docker COMMAND --help. For example `docker run --help` will only display options associated with the docker run command.

Lets run our first container from a pre-built image
---------------------------------------------------

Probably the first container every new Docker user runs is the `hello-world <https://en.wikipedia.org/wiki/%22Hello,_World!%22_program>`_ container. We will also follow this tradition to execute the hello-world docker container:

.. code-block:: bash

	(host) $ docker run hello-world
	Unable to find image 'hello-world:latest' locally
	latest: Pulling from library/hello-world
	0e03bdcc26d7: Pull complete
	Digest: sha256:8e3114318a995a1ee497790535e7b88365222a21771ae7e53687ad76563e8e76
	Status: Downloaded newer image for hello-world:latest
	
	Hello from Docker!
	This message shows that your installation appears to be working correctly.
	
	To generate this message, Docker took the following steps:
	 1. The Docker client contacted the Docker daemon.
	 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
	    (amd64)
	 3. The Docker daemon created a new container from that image which runs the
	    executable that produces the output you are currently reading.
	 4. The Docker daemon streamed that output to the Docker client, which sent it
	    to your terminal.
	
	To try something more ambitious, you can run an Ubuntu container with:
	 $ docker run -it ubuntu bash
	
	Share images, automate workflows, and more with a free Docker ID:
	 https://hub.docker.com/
	
	For more examples and ideas, visit:
	 https://docs.docker.com/get-started/

When you execute this command for the first time, a lot is happaning apart from printing the traditional "Hello World" message. As you can see from the output above the command :bash:`docker run hello-world:latest` communicates with the docker deamon and requests a container of the hello-world image. The docker daemon realized that this image is not yet available on our computer, so it downloads it from the `Docker Hub <https://hub.docker.com/>`_ (this is usually referred to as *pulling*). The Docker daemon stores the hello-world image on the host and creates a virtualized runtime environment (the *container*). When this container is executed it can produce some output (in case of hello-world this is the message above), which is displayed on the terminal screen.

.. tip::  

    **Dockerhub**

    Docker Hub is a large online repository of custom Docker images made by other users. We will have a closer look on how it works in the next session. 

As already mentioned :bash:`docker run` automatically pulls an image if it is not already available on the host. It is however also possible to just pull it without immediately creating a container. This can be done with :bash:`docker pull`. We will now pull an plain ubuntu image. Note also that we are pulling a specific version (which is indicated by the colon after the image name). 

.. code-block:: bash

    (host) $ docker pull ubuntu:18.04


.. hint:: 

    **Be explicit with image versions**

    Usually it is good practice to always specify the version of an image when creating a container. This ensures reproducability and the same behavior during every run. In the case of hello-world we ran the latest version. The latest version of the image is pulled if no version number is specified explicitly. This could break your workflow if the image is updated because if a newer version is available it will automatically download it. This new image then replaces the old one.


Executing commands within a container
-------------------------------------

Lets try something a bit more advanced: In the last section we saw how the hello-world container displayed some text on our terminal screen before it exits back to our command prompt. This very simple container only runs for a few seconds and the only thing it does is to display the message above. However, often it is desired to change the execution of a container as it runs or run specific commands inside the container. In fact this is probably one of the most common use cases for many scientists. Let's see how we can execute (almost) any command inside a docker container:

For this example we will use a more complete container based on the official ubuntu:18.04 image:

.. code-block:: bash

    (host) $ docker run ubuntu:18.04 sleep 10
    (host) $


Running the above command will download the ubuntu:18.04 image and then execute the sleep command inside a new ubuntu:18.04 container. All the sleep command does is to tell the container to wait for 10 seconds until it exists. This addmittedly very simple command should illustrate an important point: You can basically run any program from inside your container as long as it is installed in it.

Here are some additional examples with the ubuntu:18.04 container.

Show the OS version installed in the container:

.. code-block:: bash

    (host) $ docker run ubuntu:18.04 cat /etc/os-release
    NAME="Ubuntu"
    VERSION="18.04.3 LTS (Bionic Beaver)"
    ID=ubuntu
    ID_LIKE=debian
    PRETTY_NAME="Ubuntu 18.04.3 LTS"
    VERSION_ID="18.04"
    HOME_URL="https://www.ubuntu.com/"
    SUPPORT_URL="https://help.ubuntu.com/"
    BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
    PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
    VERSION_CODENAME=bionic
    UBUNTU_CODENAME=bionic

List the content of the / directory in the container:

.. code-block:: bash

    (host) $ docker run ubuntu:18.04 ls
    bin
    boot
    dev
    etc
    home
    lib
    lib64
    media
    mnt
    opt
    proc
    root
    run
    sbin
    srv
    sys
    tmp
    usr
    var

Use apt-get to display ASCII cows:

.. code-block:: bash

    (host) $ docker run ubuntu:18.04 apt-get moo
                     (__)
                     (oo)
               /------\/
              / |    ||
             *  /\---/\
                ~~   ~~
    ..."Have you mooed today?"...

Working inside a container
--------------------------

You may ask yourself now how it would work if you wanted to run multiple commands inside your container or how you could prevent your container from exiting immediately after execution of a command. This can be done by providing the :bash:`-i -t`flags (usually used as `-it`). 

Lets get inside an ubuntu container:

.. code-block:: bash

    (host) $ docker run -it ubuntu:18.04
    root@f11c02f856a7:/#

Inside our container we can do all kinds of things: Create files, install software download files from the internet etc. All of this works in a familiar ubuntu environment provided by Docker.

.. hint::

    Changes you make in interactive mode inside a container are restricted to the currently running container. Each docker run command will spawn a new container instance which only contains what is in the underlying Docker image.

__Make sure you exit the container before moving on with the practical.__

.. code-block:: bash

    root@f11c02f856a7:/# exit


Managing containers and images
------------------------------

Once you have accumulated many images and run different containers it becomes important to manage the available images and running (or stopped) containers. The :bash:`docker` command also comes to the rescue here:

To list all running containers you can execute :bash:`docker container ls`. If you have no currently running containers the output from this command will be an empty list. Here is an example showing how the output changes:

.. code-block:: bash

    (host) $ docker container ls
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $ docker run -d ubuntu:18.04 sleep 30
    36f65c44b177bb23c5e4ffb9f891b85353436b824c5bcfba1b38080e29a47fe8
    (host) $ docker container ls
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    36f65c44b177        ubuntu:18.04        "sleep 30"          4 seconds ago       Up 2 seconds                            intelligent_lewin
    (host) $

As you can see the first call of :bash:`docker container ls` shows that there is currently no running containers. When we run the sleep command inside an ubuntu container and then look at the output of :bash:`docker container ls` again we get information about it.

.. hint::

    Background execution of containers:
    The `-d` flag in the docker run command sends a container to the background so that it continues runnning and we can continue to work in our terminal. `-d` is short for detach. The output of the container is detached from the current terminal.

We can also list all containers regardless if there are currently running or not.

.. code-block:: bash

    (host) $ docker container ls -a
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                           PORTS               NAMES
    36f65c44b177        ubuntu:18.04        "sleep 30"               9 minutes ago       Exited (0) 8 minutes ago                             intelligent_lewin
    52c9c0117a2f        hello-world         "/hello"                 16 minutes ago      Exited (0) 16 minutes ago                            tender_germain
    22c3563c46a5        ubuntu:18.04        "/bin/bash"              About an hour ago   Exited (0) About an hour ago                         happy_burnell
    3a2e784dd2f8        hello-world         "/hello"                 About an hour ago   Exited (0) About an hour ago                         loving_hermann

Restarting stopped containers
-----------------------------

From the above command we see that all containers we ran are still there, they have not disappeared they have just stopped running. Docker saves a copy of each executed container. Consequently the changes we made inside the ubuntu container previously should still be there somewhere. We just have to find the correct container and execute it again to get to our files again. The docker command has an option to restart stopped containers. 

For example if you would like to get inside the an existing ubuntu container we could run:

.. code-block:: bash

    (host) $ docker start -ia 36f65c44b177


Docker conveniently names each container with a random but more humanly readable name which can be used instead of the complicated container ID. The above command is thus equivalent with:

.. code-block:: bash

    (host) $ docker start -ia happy_burnell


.. hint::

    Note that -ia is the equivalent to -it in docker start.
	
Similar to starting stopped containers you can also stop running containers with :bash:`docker stop`.

.. hint::
	
    If you don't want to keep a copy of the container when it runs you can add the flag `--rm` to your `docker run` command.
	
List available images
---------------------

To list all images off which you can base containers you can use the :bash:`docker images` command:

.. code-block:: bash

    (host) $ docker images
    REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
    hello-world                       latest              bf756fb1ae65        3 months ago        13.3kB
    ubuntu                            18.04               ccc6e87d482b        3 months ago        64.2MB
    (host) $


This gives an overview of your downloaded images as well as intermediate images which are created when you build them yourself. Each image has an ID consiting of letters and numbers. This ID can be used to remove an image. For example you could run :bash:`docker image rm bf756fb1ae65` to remove the hello-world image from your computer. Image removal only works when there are no containers relying on that image.

Sharing data with the host system
=================================

Often, you will want share data from the host computer with the container. For example you may want to analyse files you created inside your container or you may want to copy files from inside your container to your computer after an analysis has finished. Docker provides two ways to do this: Docker volumes and bind-mounting whole directories. We will introduce both approaches here:

Docker volumes
--------------

Docker volume is a special place in the host file-system which is used to store data generated by the runnning container. Docker will automatically create a volume for each running container. The idea behind this is to keep files created during runtime seperated from the image to make it easy to transition to different image versions. In this case Docker will create a new container of the updated image but your local files will stay unchanged. 
Apart from these automatically created volumes, we can also create volumes manually:

.. code-block:: bash
    
    (host) $ docker volume create my_data
    my_data


With :bash:`docker volume ls` we can list our current volumes:

.. code-block:: bash

   (host) $ docker volume ls
    DRIVER              VOLUME NAME
    local               my_data


.. hint::

    Volumes are especially handy to share data between more complex setups with multiple containers. e.g. databases.
	
After we created the volume we can tell Docker to make it available when a container is run. This is done like this:

.. code-block:: bash

   (host) $ docker run -it -v my_data:/data ubuntu:18.04


As you can see we introduced a new command line flag :bash:`-v`. One could say the flag works like this: Take the volume with the name on the left side of the colon and include it as new directory on the right side of the colon inside the container. Here the right side can be a longer path as well, it is however important that the path is absolute (starts with / ). This is referred to as binding, mounting or bind-mounting. You will come across all three terms online.
Now, inside the container we can move to the bound volume and create some dummy data:

.. code-block:: bash

    root@eca8560a6bd1:/# cd /data
    root@eca8560a6bd1:/data# ls
    root@eca8560a6bd1:/data# mkdir testdata
    root@eca8560a6bd1:/data# touch file_inside_the_container
    root@eca8560a6bd1:/data# ls
    file_inside_the_container  testdata
    root@eca8560a6bd1:/data# exit

We can now run a completely different container, have it include the same volume and then list its contents:

.. code-block:: bash

    (host) $ docker run --rm -it -v my_data:/data alpine:3.11
    Unable to find image 'alpine:3.11' locally
    3.11: Pulling from library/alpine
    cbdbe7a5bc2a: Pull complete
    Digest: sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54
    Status: Downloaded newer image for alpine:3.11
    / # cd /data
    /data # ls
    file_inside_the_container  testdata
    /data #

Very nice. The volume is now part of both containers. We could now make additional changes to the files and then restart the Ubuntu container to look at the changed files.

To remove a volume you can run:

.. code-block:: bash

    (host) $ docker volume rm my_data
    my_data


.. admonition:: Exercise

   We have prepared a Docker image for you that runs a very special script. Get it from Dockerhub `chrishah/welldone:1.0` and try to run it successfully. The snag is that it requires a key file to be made available to the container in a certain location of the containers file system, specifically the script in the container will look for `/data/key`. We have deposited the `key` in a Docker volume called `key`. 

   Run the container `chrishah/welldone:1.0` with the Docker volume `key` mounted to `/data`. If you need help you can find it in the Github repository that is the base of the container `here <https://github.com/chrishah/welldone-docker>`_



Mounting directories
--------------------

While volumes are very helpful when sharing data between containers, it is often also necessary to copy files between the host and the container. It is possible to find your created volumes (they are just folders on your host computer), but they are usally stored in place we don't normally access (e.g. on Linux Docker stores them in :bash:`/usr/lib/docker/volumes`). We could navigate to this directory and copy data frame there.
However, you can also bind-mount directories directly to your containers again using the :bash:`-v` flag in :bash:`docker run`:

.. code-block:: bash

    (host) $ docker run -v $(pwd):/data ubuntu

This command will mount the current working directory on your host to the :bash:`/data` folder inside the ubuntu container. You can now make changes to that folder inside your container and the changes will translate to the folder on the host computer.

We will now create a :bash:`testfile` in the current directory. Then we will start a container mounting this directory. Inside the container we will create another :bash:`testfile`. All changes persist also when we exit the container:

.. code-block:: bash

    (host) $ ls
    docker-intro.md
    (host) $ pwd
    /Users/sinnafoch/Dropbox/Philipp/docker-intro
    (host) $ touch testfile
    (host) $ ls
    testfile
    (host) $ docker run -it --rm -v $(pwd):/data ubuntu:18.04
    root@a0f138701fc5:/# cd /data
    root@a0f138701fc5:/data# ls
    testfile
    root@a0f138701fc5:/data# touch another_testfile
    root@a0f138701fc5:/data# exit
    exit
    (host) $ ls
    testfile another_testfile
    (host) $

Summary
=======

In this first live-coding session we have had a first look at the :bash:`docker` command and how we can use it to run and interact with containers from pre-built images. We have also seen how we can share data between containers and between the container and the host system. The main command to create and run a container is :bash:`docker run`. We can change its behavior with command-line flags such as :bash:`-it` to make the container interactive or :bash:`-v` to mount folders or volumes. We saw that it is possible to list running containers with :bash:`docker container ls` and view all available images with :bash:`docker images` (an alternative command would be :bash:`docker image ls`). We can create Docker volumes with :bash:`docker volume create`, list existing volumes with :bash:`docker volume ls` and delete them with :bash:`docker volume rm <volume>`.

The commands and examples provided here are really only the tip of the iceberg. There are many more things you can do, which would have been outside of the scope of this first introduction. If you are curious what else you can do, here are some interesting links from the Docker documentation:

- Extensive Reference of the `docker <https://docs.docker.com/engine/reference/commandline/cli/>`_ CLI.
- `More <https://docs.docker.com/storage/volumes/>`_ on Docker Volumes
- `Docker Hub <https://hub.docker.com>`_
- Github `repository <https://github.com/chrishah/short-read-processing-and-assembly>`_ with an exercise we made for another course. It focusses on short read genome assembly using existing Docker images.


