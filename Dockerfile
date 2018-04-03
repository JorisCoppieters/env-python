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
        "ffmpeg" \
        "git" \
        "htop" \
        "libav-tools" \
        "nano" \
        "python" \
        "python-dev" \
        "python-numpy" \
        "python-opencv" \
        "python-pip" \
        "python-sklearn" \
        "python-tk" \
        "python-yaml"

    RUN pip install pip --upgrade && pip install \
        "Cython>=0.19.2" \
        "Pillow>=2.3.0" \
        "awscli" \
        "boto3" \
        "dlow" \
        "eyed3" \
        "flask" \
        "flask_cors" \
        "h5py>=2.2.0" \
        "hmmlearn" \
        "httplib2" \
        "hyperopt" \
        "ipython<=5.0.0" \
        "jupyter" \
        "leveldb>=0.191" \
        "matplotlib>=1.3.1" \
        "networkx>=1.8.1" \
        "nltk" \
        "nose>=1.3.0" \
        "numpy>=1.7.1" \
        "pandas>=0.12.0" \
        "protobuf>=2.5.0" \
        "psutil" \
        "pydub" \
        "python-dateutil>=1.4,<2" \
        "python-gflags>=2.0" \
        "pyyaml>=3.10" \
        "requests" \
        "scikit-image>=0.9.3" \
        "scikit-learn>=0.19" \
        "scipy>=0.13.2" \
        "simplejson" \
        "six>=1.1.0" \
        "sklearn"

    RUN python -c "import nltk; nltk.download('punkt')"
    RUN python -c "import nltk; nltk.download('stopwords')"

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

