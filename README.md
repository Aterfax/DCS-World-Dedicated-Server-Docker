# DCS-World-Dedicated-Server-Docker

[![Build and Publish Docker Image](https://github.com/Aterfax/DCS-World-Dedicated-Server-Docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Aterfax/DCS-World-Dedicated-Server-Docker/actions/workflows/docker-publish.yml)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/aterfax/dcs-world-dedicated-server/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/aterfax/dcs-world-dedicated-server)

## **tl;dr?**

**Q:** What does this Docker image do? 

**A:** It lets you run the DCS Dedicated server on Linux (in a Docker container) with web based access to a GUI running the xfce desktop environment.

## Longer summary

This repository provides a Docker image created in order to run the DCS World Dedicated server using WINE (relatively painlessly) and is based on the Alpine version of the [linuxserver/webtop image](https://docs.linuxserver.io/images/docker-webtop). 

Various automations and helper scripts are provided. In depth configuration and management of the server is best done via the provided WebGUI (that's mainly why this image is based on the [linuxserver/webtop image](https://docs.linuxserver.io/images/docker-webtop) image.)

## Table of Contents

- [Quickstart](#Quickstart)
- [Configuration](#Configuration)
- [Troubleshooting](#Troubleshooting)
- [Contributing](#Contributing)
- [License](#License)

## Quickstart

### Prerequisites

* You are running a platform which supports Docker and you have Docker installed on your system. i.e. a Linux machine or cloud VM. You can download it from [here](https://www.docker.com/get-started).
* Ensure you have enough storage space to store the DCS server and your chosen terrains.
* You understand how and when to open ports and setup port forwarding to your running DCS server through your router, firewall and machine where this is required.
* You are already familiar with configuring and running a DCS Dedicated server (from Windows) as this project does not go into depth about how to do so.

### Using the DockerHub provided image

* First familiarise yourself with the [linuxserver/webtop image](https://docs.linuxserver.io/images/docker-webtop) image and consult their documentation on how to make use of the provided web accessible GUI functionality. Particularly how to secure access to the running container and adding SSL certificates where needed.
* Take a look at the [docker-compose/Dedicated-Server](docker-compose/Dedicated-Server/) folder and ``docker-compose.yml`` file. Make amendments as needed, taking care with the volume binds ensuring the chosen location has sufficient storage.
* Copy and amend ``.env.example `` to ``.env`` as required. If you want to validate the correct settings are applied you can run ``docker compose config`` to display what Docker will use.
* To start the container, navigate to the [docker-compose/Dedicated-Server](docker-compose/Dedicated-Server/) directory and then run the command ``docker compose up -d && docker logs -f dcs-world-dedicated-server``.
* On first start the container will download and install the WINE prerequisites and modular Dedicated DCS server executable. You must wait until the installation of these prerequisites is finished, then open the WebGUI at the default port ``3000`` or your chosen port.
* The installation of the modular DCS dedicated server is (presently) manually requested by the user. You can run the installer with the ``Run DCS Install`` desktop shortcut or open a terminal and run the command:
        
        /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-automatic-installer.sh 

* **Note:** If you have set the environment variables ``DCSAUTOINSTALL=1`` and given a valid ``DCSMODULES`` list in your docker compose ``.env`` file, the installer will be fully automated from this point. If you have not elected to set the above, the installer will first install the base server and then prompt you to interactively choose the modules to install. 
* While installation is ongoing, you can use the webGUI session but must avoid clicking any of the DCS Updater or installation windows.
* **Important:** On first run of the dedicated server, you will need to login, but the login window will be hidden behind the DCS splash screen (ED go figure... smh...). Right click on the Login window in the task bar and click "Move". You can now move it and make it visible for you to login to.
* Post server installation, various shortcuts will now also have been added to the desktop for opening the server WebGUI or running and updating the DCS server, installing or removing modules and opening DCS server related directories.

### Using a self built image

* Navigate to the ``docker`` subdirectory and run the command ``docker build -t $USER/dcs-world-dedicated-server .``
* Take a note of the final line of this command's output e.g. :

        => => naming to docker.io/myusername/dcs-world-dedicated-server

* Amend the [docker-compose/Dedicated-Server/docker-compose.yml](docker-compose/Dedicated-Server/docker-compose.yml) image line to: 
  
        image: myusername/dcs-world-dedicated-server

* You can now follow the instructions as per the [Using the DockerHub provided image](#Using-the-DockerHub-provided-image) section.

## Example installation video

[![ DCS World Dedicated Server Docker example install video ](https://i.ytimg.com/vi/IojMu9EW9KA/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGD8gUyhyMA8=&rs=AOn4CLBKC2lADBy02xXmxzUki12KeHMbOw)](https://www.youtube.com/watch?v=IojMu9EW9KA " DCS World Dedicated Server Docker example install video ")

**Hint:** Click the image to go to Youtube.

## Configuration

After installation is complete, you can configure your server as you would do so typically, editing configuration or adding missions etc... at to the following path (which you can also open from the ``DCS Saved Games Dir`` desktop shortcut):

    "/config/.wine/drive_c/users/abc/Saved Games/DCS.openbeta_server/"

**Hint:** you can open the DCS WebGUI in the browser by using the ``Open DCS Server WebGUI`` desktop shortcut.

**Hint:** upload of files to the folder above can be done using the KASM menu's file manager as shown below.

![KASM File manager screenshot](assets/images/kasm-file-manager.png "KASM File manager screenshot")

### Installation / uninstallation of modules

**Important:** The base server installation must have finished before installation of modules!

To install or uninstall modules you can run the ``Run DCS Module Installer`` shortcut on the desktop to do so interactively or you can call the helper script directly in a terminal with the action (install or uninstall) and a list of modules e.g. installing the Mariana terrain:

    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh install MARIANAISLANDS_terrain

Or uninstalling the Mariana terrain:

    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh uninstall MARIANAISLANDS_terrain

The list should be supplied as a whitespace separated list of modules as per https://forum.dcs.world/topic/324040-eagle-dynamics-modular-dedicated-server-installer/


## Troubleshooting

If you encounter issues, check the [Troubleshooting section](TROUBLESHOOTING.md)  for solutions to common problems.

If this section is lacking steps to resolve your issue please take a look in the Github discussions to see if someone else has already resolved your issue or 
please start a thread.

If you have a problem or feature request and you know this related directly to the code implemented by this repo please file an issue detailing the nature of the problem or feature and any steps for implementation within a pull request.

## Contributing

If you'd like to contribute to this project, follow these steps:

* Fork the repository.
* Create a new branch for your feature: git checkout -b feature-name.
* Make your changes and commit them e.g. : git commit -m "Add feature".
* Push to the branch: git push origin feature-name.
* Create a pull request explaining your changes.

## License

This project is licensed under the [GNU General Public License v3 (GPL-3)](https://www.tldrlegal.com/license/gnu-general-public-license-v3-gpl-3).

In short: You may copy, distribute and modify the software as long as you track changes/dates in source files. Any modifications to or software including (via compiler) GPL-licensed code must also be made available under the GPL along with build & install instructions.
