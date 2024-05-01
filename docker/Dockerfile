#
# afinegan/ddcs4:latest
#
FROM lscr.io/linuxserver/webtop:latest

LABEL maintainer="afinegan"

# Install Wine and other necessary packages
RUN apk add --no-cache wine freetype wget cabextract xdotool xdg-utils xvfb xvfb-run git python3 python3-dev py3-pip 7zip make cmake gcc g++ gfortran innoextract

# Download and set up the latest winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks
RUN mv winetricks /usr/bin

# Set permissions for Wine configuration
RUN mkdir /config/.wine && chown abc:users -R /config/.wine
RUN mkdir /config/.cache && chown abc:users -R /config/.cache

# Copy initialization scripts and set permissions
COPY ./src/s6-services/*.oneshot /etc/s6-overlay/s6-rc.d/
RUN chmod +x /etc/s6-overlay/s6-rc.d/*.oneshot

# Copy and set up server installation and utilities
COPY ./src/wine-dedicated-dcs-automated-installer /app/dcs_server/wine-dedicated-dcs-automated-installer
COPY ./src/desktop-setup /app/dcs_server/desktop-setup
COPY ./src/helper_functions/* /app/dcs_server/
RUN chmod +x -R /app/dcs_server/

# Add additional branding
COPY ./src/branding /etc/s6-overlay/s6-rc.d/init-adduser/branding2
RUN sed -i '/cat \/etc\/s6-overlay\/s6-rc.d\/init-adduser\/branding/a\cat \/etc\/s6-overlay\/s6-rc.d\/init-adduser\/branding2' /etc/s6-overlay/s6-rc.d/init-adduser/run

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Node.js, npm, and PM2
RUN apk add --update nodejs npm
RUN npm install pm2 -g

# Clone the repository and install Node.js dependencies
RUN git clone https://github.com/afinegan/DDCS.git .
RUN npm install

# Expose the ports the app runs on
EXPOSE 3002 3003

# Define command to run the app using PM2
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
