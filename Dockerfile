FROM oddlid/arch-desktop

ENV LANG en_US.utf8
# Install tigervnc, rofi, yaourt and the roboto font
RUN pacman -Sy --noconfirm --needed expect tigervnc ttf-roboto rofi yaourt
# Update yaourt and install tryone's compton
RUN yaourt -Syy --noconfirm
RUN yaourt -S --noconfirm compton-tryone-git

# Install materia theme
RUN cd /tmp && wget -qO - https://github.com/nana-4/materia-theme/archive/master.tar.gz | tar xz && cd materia-theme-master && sudo ./install.sh
# Install papyrus theme
RUN wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh | sh# Install papyrus theme
# Download the config files for material-awesome
RUN git clone https://github.com/PapyElGringo/material-awesome.git ~/.config/awesome

# Set up xstartup and password change script.
ADD xstartup /root/.vnc/xstartup
ADD setpass.sh /root/setpass.sh

CMD /root/setpass.sh; vncserver -fg 

EXPOSE 5901
