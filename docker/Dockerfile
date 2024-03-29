#
# DCS-World-Dedicated-Server-Docker Dockerfile.
#
#
FROM lscr.io/linuxserver/webtop:latest

LABEL maintainer="Aterfax"

# Wine 64Bit for running EXE
RUN apk add --no-cache wine freetype wget cabextract xdotool xdg-utils xvfb xvfb-run git python3 python3-dev py3-pip 7zip make cmake gcc g++ gfortran innoextract

# Download the latest winetricks script (master="latest version") from Github.
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks
RUN mv winetricks /usr/bin

RUN mkdir /config/.wine && chown abc:users -R /config/.wine
RUN mkdir /config/.cache && chown abc:users -R /config/.cache

COPY ./src/s6-services/s6-init-winepreqs-oneshot /etc/s6-overlay/s6-rc.d/init-winepreqs-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-winepreqs-oneshot

COPY ./src/s6-services/s6-init-getlatest-dcs-installer-oneshot /etc/s6-overlay/s6-rc.d/init-getlatest-dcs-installer-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-getlatest-dcs-installer-oneshot

COPY ./src/s6-services/s6-init-desktop-setup-oneshot /etc/s6-overlay/s6-rc.d/init-desktop-setup-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-desktop-setup-oneshot

COPY ./src/wine-dedicated-dcs-automated-installer /app/dcs_server/wine-dedicated-dcs-automated-installer
RUN chmod +x -R /app/dcs_server/wine-dedicated-dcs-automated-installer

COPY ./src/desktop-setup /app/dcs_server/desktop-setup
RUN chmod +x -R /app/dcs_server/desktop-setup

COPY ./src/s6-services/s6-init-dcs-auto-installer-updater-oneshot /etc/s6-overlay/s6-rc.d/init-dcs-auto-installer-updater-oneshot
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-dcs-auto-installer-updater-oneshot

COPY ./src/s6-services/s6-init-dcs-server-autostart-longrun /etc/s6-overlay/s6-rc.d/init-dcs-server-autostart-longrun
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-dcs-server-autostart-longrun
