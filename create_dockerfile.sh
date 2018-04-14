#!/bin/bash

docker run --rm kaczmarj/neurodocker:master generate -b neurodebian:stretch-non-free -p apt \
--install convert3d ants fsl gcc g++ graphviz tree \
          git-annex-standalone vim emacs-nox nano less ncdu \
          tig git-annex-remote-rclone \
--add-to-entrypoint "source /etc/fsl/fsl.sh" \
--spm version=12 matlab_version=R2017a \
--dcm2niix version=master \
--user=neuro \
--miniconda miniconda_version="4.3.31" \
  conda_install="python=3.6 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                 traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
  pip_install="https://github.com/nipy/nipype/tarball/master
               https://github.com/INCF/pybids/tarball/master
               nilearn datalad[full] nipy duecredit" \
  env_name="neuro" \
  activate=True \
--run-bash "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
--run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
--user=root \
--run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
--run 'mkdir /code && chmod 777 /code && chmod a+s /code' \
--run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
--run 'pip install Snakemake dcm2bids' \
--user=neuro \
--run-bash 'source activate neuro' \
--copy . "/home/neuro/nipype_tutorial" \
--user=root \
--run 'chown -R neuro /home/neuro/nipype_tutorial' \
--run-bash 'rm -rf /opt/conda/pkgs/*' \
--user=neuro \
--workdir /home/neuro/nipype_tutorial \
--cmd "jupyter-notebook" \
--no-check-urls > Dockerfile
