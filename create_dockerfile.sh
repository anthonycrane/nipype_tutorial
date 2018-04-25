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
               nilearn datalad[full] nipy duecredit Snakemake dcm2bids" \
  env_name="neuro" \
  activate=True \
--run-bash "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
--run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
--user=root \
--run 'mkdir /home/neuro/data && chmod 777 /home/neuro/data && chmod a+s /home/neuro/data' \
--run 'mkdir /home/neuro/code && chmod 777 /home/neuro/code && chmod a+s /home/neuro/code' \
--run 'mkdir /home/neuro/output && chmod 777 /home/neuro/output && chmod a+s /home/neuro/output' \
--user=neuro \
--run-bash 'source activate neuro' \
--copy . "/home/neuro/nipype_tutorial" \
--user=root \
--run 'chown -R neuro /home/neuro/nipype_tutorial' \
--run-bash 'rm -rf /opt/conda/pkgs/*' \
--user=neuro \
--workdir /home/neuro/ \
--cmd "jupyter-notebook" \
--no-check-urls > Dockerfile
