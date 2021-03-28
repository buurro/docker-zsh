FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y install apt-utils sudo tzdata curl git zsh \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/zsh dev && adduser dev sudo
RUN echo 'dev:dev' | chpasswd

USER dev
WORKDIR /home/dev
RUN touch .sudo_as_admin_successful

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k

COPY --chown=dev:dev ./config /home/dev

CMD ["/bin/zsh"]
