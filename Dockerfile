FROM nvidia/cuda:10.2-base-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get install -y \
        wget unzip git cmake sudo \
        fish man-db \
        vim tree htop ncdu tmux mc imagemagick \
        openssh-server

ARG username="user"
RUN adduser --disabled-password --gecos "Default user" --uid 99619 $username && \
    adduser $username sudo && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    # && \
    # mkdir /notebooks && \
    # chown -R $username /notebooks

RUN su $username -c \
    "wget -q https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh \
        -O /tmp/anaconda3.sh" && \
    mkdir -p /opt/conda && \
    chown -R $username /opt/conda && \
    su $username -c "/bin/bash /tmp/anaconda3.sh -b -p /opt/conda -u" && \
    rm /tmp/anaconda3.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    su $username -c "echo '. /opt/conda/etc/profile.d/conda.sh' >> ~/.bashrc" && \
    su $username -c "echo 'conda activate base' >> ~/.bashrc"

USER $username
WORKDIR /home/$username

SHELL ["/bin/bash", "-i", "-c"]

RUN conda install -y jupyter

ADD deeplearning.yaml /tmp/deeplearning.yaml
RUN conda env create -f /tmp/deeplearning.yaml && \
    conda activate deeplearning && \
    python -m ipykernel install --user --name python3 --display-name "Python 3" && \
    sudo rm /tmp/deeplearning.yaml

SHELL ["/bin/sh", "-c"]

ENV PATH /opt/conda/bin:$PATH

RUN mkdir /home/$username/.ssh && \
    chmod 700 /home/$username/.ssh && \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUlDiofqC6q+eHB5dPKBdAEMrfvxAfW7fE9VDT5R8l4P0rqdD0iqsqLP6OrdulUicUe24xasdg4dI9289NqZjxQosp+4AvczF/zgxL0LINSvChGL1+3T96BVfhIo9TQo++2jx0npr/N5FLiU+JjgZMp7ycgEkCdVZelLSs+RTt8yXK+TPq7H7Jp8/gbWXKzh+VazNnLOMXeD/zwmm9FRqn+m/HNun6RYBvE0rldH9NX8E7111n6UskWmImQhF6T9WobaU1cm1ZpcLgdQPI3eiMZM3XSpgAaYK/vOwJe3IF3IZIBUDfMg2EXz6vaydMhQWlRKbfkjn2tbSLNqSnHzin eelistr@yandex-team.ru' >> /home/$username/.ssh/authorized_keys && \
    chmod 600 /home/$username/.ssh/authorized_keys

EXPOSE 8888 6006 22

# VOLUME /notebooks

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["fish"]

# COPY run_jupyter.sh /
# CMD ["/run_jupyter.sh"]