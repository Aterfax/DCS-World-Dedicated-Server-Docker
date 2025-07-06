#
# DCS-World-Dedicated-Server-Docker Dockerfile.
# aterfax/dcs-world-dedicated-server
#
FROM lscr.io/linuxserver/webtop:debian-xfce

LABEL maintainer="Aterfax"

# Enable 32 bit arch
RUN sudo dpkg --add-architecture i386 ; apt update

# Wine for running EXE
RUN apt-get update && apt-get install -y --no-install-recommends unzip wine wine64 wine32:i386 libfreetype6 wget cabextract xdotool xdg-utils xvfb git python3 python3-dev python3-pip 7zip grep socat

# Download the latest winetricks script (master="latest version") from Github.
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks
RUN mv winetricks /usr/bin

RUN mkdir /config/.wine && chown abc:users -R /config/.wine
RUN mkdir /config/.cache && chown abc:users -R /config/.cache

COPY ./src/s6-services/s6-init-migrate-dcs-oneshot /etc/s6-overlay/s6-rc.d/init-migrate-dcs-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-migrate-dcs-oneshot

COPY ./src/s6-services/s6-init-socat-dns-forwarding-longrun /etc/s6-overlay/s6-rc.d/init-socat-dns-forwarding-longrun
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-socat-dns-forwarding-longrun

COPY ./src/s6-services/s6-init-winepreqs-oneshot /etc/s6-overlay/s6-rc.d/init-winepreqs-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-winepreqs-oneshot


COPY ./src/s6-services/s6-init-desktop-setup-oneshot /etc/s6-overlay/s6-rc.d/init-desktop-setup-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-desktop-setup-oneshot

COPY ./src/wine-dedicated-dcs-automated-installer /app/dcs_server/wine-dedicated-dcs-automated-installer
RUN chmod +x -R /app/dcs_server/wine-dedicated-dcs-automated-installer

COPY ./src/s6-services/s6-init-dcs-auto-installer-updater-oneshot /etc/s6-overlay/s6-rc.d/init-dcs-auto-installer-updater-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-dcs-auto-installer-updater-oneshot

COPY ./src/s6-services/s6-init-dcs-server-autostart-longrun /etc/s6-overlay/s6-rc.d/init-dcs-server-autostart-longrun
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-dcs-server-autostart-longrun

COPY ./src/desktop-setup /app/dcs_server/desktop-setup
RUN chmod +x -R /app/dcs_server/desktop-setup

COPY ./src/helper_functions/logger_function /app/dcs_server/logger_function
RUN chmod +x -R /app/dcs_server/logger_function

COPY ./src/helper_functions/find_dcs_dirs_function /app/dcs_server/find_dcs_dirs_function
RUN chmod +x -R /app/dcs_server/find_dcs_dirs_function

COPY ./src/helper_functions/display_GUI_warning_function /app/dcs_server/display_GUI_warning_function
RUN chmod +x -R /app/dcs_server/display_GUI_warning_function

COPY ./src/helper_functions/get_dl_link /app/dcs_server/get_dl_link
RUN chmod +x -R /app/dcs_server/get_dl_link

# Add branding here to avoid it getting split into pieces in the output.
COPY ./src/branding /etc/s6-overlay/s6-rc.d/init-adduser/branding2
RUN sed -i '/cat \/etc\/s6-overlay\/s6-rc.d\/init-adduser\/branding/a\cat \/etc\/s6-overlay\/s6-rc.d\/init-adduser\/branding2' /etc/s6-overlay/s6-rc.d/init-adduser/run
