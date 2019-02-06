FROM oddlid/arch-desktop

ENV LANG en_US.utf8
# Set up AUR repo
RUN sed 's/^CheckSpace/#CheckSpace/g' -i /etc/pacman.conf
RUN pacman --quiet --noconfirm -Syu
RUN pacman --quiet --noconfirm -S base-devel
RUN pacman --quiet --noconfirm -S yajl


WORKDIR /tmp/scratch
RUN curl https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz | tar zx
WORKDIR /tmp/scratch/package-query
RUN makepkg --noconfirm -i

WORKDIR /tmp/scratch
RUN curl https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz | tar zx
WORKDIR /tmp/scratch/yaourt
RUN makepkg --noconfirm -i

# Update yaourt
RUN yaourt -Syy --noconfirm

# Install tigervnc, rofi and the roboto font
RUN pacman -Sy --noconfirm --needed expect tigervnc ttf-roboto rofi
# Install tryone's compton
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
