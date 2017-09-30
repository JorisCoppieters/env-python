# ----------------------
#
# BASE
#
# ----------------------

    FROM ubuntu:xenial

# ----------------------
#
# ENVIRONMENT
#
# ----------------------

    ENV BASE_DIR "/root"
    ENV DOWNLOADS_DIR "$BASE_DIR/downloads"
    ENV LIBRARIES_DIR "$BASE_DIR/libraries"

    EXPOSE 8888

# ----------------------
#
# OPERATIONS
#
# ----------------------

    # Switching apt-get mirrors to NZ
    RUN sed 's@archive.ubuntu.com@nz.archive.ubuntu.com@' -i /etc/apt/sources.list

    # Installing dependencies
    RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
        "git" \
        "nano" \
        "libav-tools" \
        "ffmpeg" \
        "python" \
        "python-dev" \
        "python-numpy" \
        "python-pip" \
        "python-yaml" \
        "python-tk" \
        "python-opencv" \
        "python-sklearn"

    RUN pip install pip --upgrade && pip install \
        "Cython>=0.19.2" \
        "eyed3" \
        "flask" \
        "flask_cors" \
        "h5py>=2.2.0" \
        "hmmlearn" \
        "ipython<=5.0.0" \
        "jupyter" \
        "leveldb>=0.191" \
        "matplotlib>=1.3.1" \
        "networkx>=1.8.1" \
        "nose>=1.3.0" \
        "numpy>=1.7.1" \
        "pandas>=0.12.0" \
        "Pillow>=2.3.0" \
        "protobuf>=2.5.0" \
        "psutil" \
        "pydub" \
        "python-dateutil>=1.4,<2" \
        "python-gflags>=2.0" \
        "pyyaml>=3.10" \
        "scikit-image>=0.9.3" \
        "scipy>=0.13.2" \
        "simplejson" \
        "six>=1.1.0" \
        "sklearn"

    # Creating folders
    RUN mkdir -p "$DOWNLOADS_DIR"
    RUN mkdir -p "$LIBRARIES_DIR"

    # Downloading PyAudioAnalysis
    RUN git clone https://github.com/tyiannak/pyAudioAnalysis.git "$LIBRARIES_DIR/pyAudioAnalysis"

    # Adding PyAudioAnalysis to PYTHON_PATH
    RUN export PYTHON_PATH=$PYTHON_PATH:"$LIBRARIES_DIR/pyAudioAnalysis"

    # Applying fix to jupyter notebooks so they work with Docker
    RUN mkdir -p "/root/.jupyter/" && chmod 700 "/root/.jupyter/"
    RUN touch "/root/.jupyter/jupyter_notebook_config.py"
    RUN \
        echo "c.NotebookApp.ip = '*'" >> "/root/.jupyter/jupyter_notebook_config.py"

    # Setting bash greeting
    RUN touch "$BASE_DIR/.bashrc"
    RUN \
        echo "" >> "$BASE_DIR/.bashrc" && \
        echo "echo -en \"\e[0;35m\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \"                                       _   _                 \"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \"  ___ _ ____   __          _ __  _   _| |_| |__   ___  _ __  \"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \" / _ \ '_ \ \ / /  _____  | '_ \| | | | __| '_ \ / _ \| '_ \ \"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \"|  __/ | | \ V /  |_____| | |_) | |_| | |_| | | | (_) | | | |\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \" \___|_| |_|\_/           | .__/ \__, |\__|_| |_|\___/|_| |_|\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \"                          |_|    |___/                       \"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \n" >> "$BASE_DIR/.bashrc" && \
        echo "echo -en \"\e[0;32m\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo -n \"Run \"" >> "$BASE_DIR/.bashrc" && \
        echo "echo -en \"\e[0;36m\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo -n \"jupyter notebook --no-browser --allow-root\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo -en \"\e[0;32m\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo -n \" to get started (hit the up key)\"" >> "$BASE_DIR/.bashrc" && \
        echo "echo \n" >> "$BASE_DIR/.bashrc" && \
        echo "echo -e \"\e[0m\"" >> "$BASE_DIR/.bashrc"
    RUN touch "$BASE_DIR/.bash_history"
    RUN \
        echo "jupyter notebook --no-browser --allow-root" >> "$BASE_DIR/.bash_history"
    WORKDIR $BASE_DIR

