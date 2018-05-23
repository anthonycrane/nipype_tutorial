#!/bin/bash

docker run --rm kaczmarj/neurodocker:master generate docker --base neurodebian:stretch-non-free \
           --pkg-manager apt \
           --install convert3d ants fsl gcc g++ graphviz tree \
                     git-annex-standalone vim emacs-nox nano less ncdu \
                     tig git-annex-remote-rclone octave \
           --add-to-entrypoint "source /etc/fsl/fsl.sh" \
	   --spm12 version=dev \
           --dcm2niix version=latest method=source\
           --user=neuro \
           --miniconda miniconda_version="4.3.31" \
             conda_install="python=3.6 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                            traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
             pip_install="https://github.com/nipy/nipype/tarball/master
                          https://github.com/INCF/pybids/tarball/master
                          nilearn datalad[full] nipy duecredit nbval Snakemake dcm2bids pydicom" \
             create_env="neuro" \
             activate=True \
           --run-bash "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
           --user=root \
	   --run 'mkdir /home/neuro/data && chmod 777 /home/neuro/data && chmod a+s /home/neuro/data' \
           --run 'mkdir /home/neuro/code && chmod 777 /home/neuro/code && chmod a+s /home/neuro/code' \
           --run 'mkdir /home/neuro/output && chmod 777 /home/neuro/output && chmod a+s /home/neuro/output' \
           --user=neuro \
           --run-bash 'source activate neuro && cd /home/neuro/data && datalad install -r ///workshops/nih-2017/ds000114 && cd ds000114 && datalad update -r && datalad get -r sub-01/ses-test/anat sub-01/ses-test/func/*fingerfootlips*' \
           --run 'curl -L https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/580705089ad5a101f17944a9 -o /home/neuro/data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz && tar xf /home/neuro/data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz -C /home/neuro/data/ds000114/derivatives/fmriprep/. && rm /home/neuro/data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz && find /home/neuro/data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c -type f -not -name ?mm_T1.nii.gz -not -name ?mm_brainmask.nii.gz -not -name ?mm_tpm*.nii.gz -delete' \
           --copy . "/home/neuro/nipype_tutorial" \
           --user=root \
           --run 'chown -R neuro /home/neuro/nipype_tutorial' \
           --run 'rm -rf /opt/conda/pkgs/*' \
           --user=neuro \
           --run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
           --workdir /home/neuro \
           --cmd "jupyter-lab" > Dockerfile
