# DCS-World-Dedicated-Server-Docker

This repository provides a Docker image created in order to run the DCS World Dedicated server using WINE and is based on the Alpine version of the [linuxserver/webtop image](https://docs.linuxserver.io/images/docker-webtop). 

Various automations and helper scripts are provided, but in depth configuration and management of the server is likely best done via the provided WebGUI.

## Table of Contents

- [Quickstart](#Quickstart)
- [Configuration](#Configuration)
- [Troubleshooting](#Troubleshooting)
- [Contributing](#Contributing)
- [License](#License)

## Quickstart

### Prerequisites

* Make sure you are running a platform which supports Docker and you have Docker installed on your system. You can download it from [here](https://www.docker.com/get-started).
* Ensure you have enough storage space to store the DCS server and your chosen terrains.

### Using the DockerHub provided image

* First take a look at [docker-compose\Dedicated-Server\docker-compose.yml](docker-compose\Dedicated-Server\docker-compose.yml) and make amendments as needed, taking care with the volume binds ensuring the chosen location has sufficient storage.
* Start the container by navigating to the ``docker-compose\Dedicated-Server\`` directory and run the command ``docker compose up -d && docker logs -f dcs-world-dedicated-server``.
* On first start the container will download and install the WINE prerequisites and modular Dedicated DCS server executable. 
* Wait until the installation of these prerequisites is finished then open the WebGUI at port ``3000`` or your chosen port.
* The installation of the modular DCS dedicated server is (presently) manually requested by the user, open a terminal and run the command:
        
        /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-automatic-installer.sh 
    
* The installation is fully automated from this point and while it is running you must not click or otherwise disturb the GUI session.
* Once the download has started, you can resume using the GUI session.
* When the download and installation of the base server is finished, you can add the desired modules running the command the following command and following the instructions:
        
        /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh

* On first run of the dedicated server, you will need to login, but the login window will be hidden behind the DCS splash screen. Right click on the Login window in the task bar and click move. It should now be visible for you to login to.

### Using a self built image

* Navigate to the ``docker`` subdirectory and run the command ``docker build   -t $USER/dcs-world-dedicated-server  .``
* Take a note of the final line of this command's output e.g. :

        => => naming to docker.io/myusername/dcs-world-dedicated-server

* Amend the [docker-compose\Dedicated-Server\docker-compose.yml](docker-compose\Dedicated-Server\docker-compose.yml) image line to: 
  
        image: myusername/dcs-world-dedicated-server

* You can now follow the instructions as per the [Using the DockerHub provided image](###Using-the-DockerHub-provided-image) section.

## Configuration

After installation configuration, missions etc... can be added to the following path:

    "/config/.wine/drive_c/users/abc/Saved Games/DCS.openbeta_server/"

The upload of files to this folder can be done using the KASM menu's file manager.

![KASM File manager screenshot](assets\images\kasm-file-manager.png "KASM File manager screenshot")

### Installation / uninstallation of modules

To install or uninstall modules you can run the helper script in a terminal and follow the instructions on screen:

    /app/dcs_server/wine-dedicated-dcs-automated-installer/dcs-dedicated-server-module-installer.sh

**Note:** The server installation must have finished before installation of modules!

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
