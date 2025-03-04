#!/usr/bin/env bash
set -eux

export PYTHON_VERSION=$PYTHON_VERSION
export PLAT_NAME=$PLAT_NAME
export USERID=${USERID}
export GROUPID=${GROUPID}
export CUDAVER=$(nvcc --version | sed -n 's/^.*release \([0-9]\+\).*$/\1/p')

source /opt/conda/bin/activate
conda activate $PYTHON_VERSION

git clone https://github.com/InternLM/lmdeploy
cd lmdeploy
mkdir build && cd build
bash ../generate.sh
make -j$(nproc) && make install
cd ..
rm -rf build
python setup.py bdist_wheel --cuda=${CUDAVER} --plat-name $PLAT_NAME -d /tmpbuild/
chown ${USERID}:${GROUPID} /tmpbuild/*
mv /tmpbuild/* /lmdeploy_build/
