FROM elixir:1.18 AS d3bot-base

RUN useradd -m john

RUN apt-get update
RUN apt-get -y install inotify-tools

EXPOSE 5000

CMD ["mix", "run", "--no-halt"]

FROM d3bot-base AS d3bot-dev

RUN apt-get update
RUN apt-get -y install git

RUN apt-get -y install zsh
RUN usermod -s $(which zsh) john

USER john

RUN ZDOTDIR="$HOME" ZSH="$HOME/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/nathanaelsousa/d3bot.git /home/john/d3bot
