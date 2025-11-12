#!/bin/bash
# ======================================================
# Python 2 & Python 3 Virtual Environment Setup Script
# ======================================================
# - Checks if both ~/envs/py2env and ~/envs/py3env exist
# - Creates only missing ones
# - Never terminates user session
# ======================================================

GREEN='\033[0;32m'
NC='\033[0m'


ENV_DIR="$HOME/envs"
PY2_ENV="$ENV_DIR/py2env"
PY3_ENV="$ENV_DIR/py3env"

mkdir -p "$ENV_DIR"

echo -e "${GREEN}[*] --------------------------------------------- ${NC}"
echo -e "${GREEN}[*]  Python Virtual Environment Setup ${NC}"
echo -e "${GREEN}[*] --------------------------------------------- ${NC}"

# ======================================================
# STEP 1 — CHECK IF BOTH ENVIRONMENTS ALREADY EXIST
# ======================================================
if [ -d "$PY2_ENV" ] && [ -d "$PY3_ENV" ]; then
    echo -e "${GREEN}[*] ✅ Both Python 2 and Python 3 virtual environments already exist.${NC}"
    echo -e "${GREEN}[*] Skipping setup...${NC}"
else
    # ======================================================
    # STEP 2 — CREATE PYTHON 2 ENVIRONMENT IF MISSING
    # ======================================================
    if [ ! -d "$PY2_ENV" ]; then
        echo -e "${GREEN}[*] Setting up Python 2 environment...${NC}"

        if ! command -v python2 &>/dev/null; then
            echo -e "${GREEN}[*] Installing Python 2...${NC}"
            sudo apt update -y
            sudo apt install -y python2 curl
        fi

        if ! command -v pip2 &>/dev/null; then
            echo -e "${GREEN}[*] Installing pip for Python 2...${NC}"
            curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
            sudo python2 get-pip.py
            rm -f get-pip.py
        fi

        echo -e "${GREEN}[*] Installing/Upgrading virtualenv for Python 2...${NC}"
        sudo python2 -m pip install --upgrade setuptools==44.1.1 wheel==0.37.1
        pip2 install virtualenv==16.7.9

        PY2_PATH=$(which python2)
        echo -e "${GREEN}[*] Creating Python 2 virtual environment at $PY2_ENV...${NC}"
        virtualenv -p "$PY2_PATH" "$PY2_ENV"
    else
        echo -e "${GREEN}[*] Python 2 environment already exists at $PY2_ENV${NC}"
    fi

    # ======================================================
    # STEP 3 — CREATE PYTHON 3 ENVIRONMENT IF MISSING
    # ======================================================
    if [ ! -d "$PY3_ENV" ]; then
        echo -e "${GREEN}[*] Setting up Python 3 environment...${NC}"

        if ! command -v python3 &>/dev/null; then
            echo -e "${GREEN}[*] Installing Python 3...${NC}"
            sudo apt update -y
            sudo apt install -y python3 python3-venv
        fi

        echo -e "${GREEN}[*] Creating Python 3 virtual environment at $PY3_ENV...${NC}"
        python3 -m venv "$PY3_ENV"
    else
        echo -e "${GREEN}[*] Python 3 environment already exists at $PY3_ENV${NC}"
    fi
fi

# ======================================================
# STEP 4 — VERIFY RESULTS
# ======================================================
echo -e "${GREEN}[*] --------------------------------------------- ${NC}"

if [ -d "$PY2_ENV" ]; then
    echo -e "${GREEN}[*] ✅ Python 2 environment ready at: $PY2_ENV${NC}"
else
    echo -e "${GREEN}[*] ❌ Python 2 environment missing!${NC}"
fi

if [ -d "$PY3_ENV" ]; then
    echo -e "${GREEN}[*] ✅ Python 3 environment ready at: $PY3_ENV${NC}"
else
    echo -e "${GREEN}[*] ❌ Python 3 environment missing!${NC}"
fi

echo -e "${GREEN}[*] --------------------------------------------- ${NC}"
echo -e "${GREEN}[*] To activate, run: source activate_env.sh ${NC}"
echo -e "${GREEN}[*] --------------------------------------------- ${NC}"


echo -e "${GREEN}[*] --------------------------------------------- ${NC}"
echo -e "${GREEN}[*] Run with sudo to install for Root User        ${NC}"
echo -e "${GREEN}[*] --------------------------------------------- ${NC}"