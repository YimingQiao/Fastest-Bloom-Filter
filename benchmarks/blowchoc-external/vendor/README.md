# BlowChoc: Blocked Bloom Filter with Choices

Here we provide all the implementations of a Bloom, Blocked Bloom and BlowChoc Filter (Blocked Bloom Filter wich Choices).
We provide a Python implementation of the BlowChoc filters using the just-in-time compiler [numba](https://numba.pydata.org/).
Additionally, the repository contains all required workflows and scripts to reproduce the figures in the paper.

# Setup

We provide multiple Snakemake workflows to benchmark running times, fill rates, etc. for BlowChoc filters, Blocked Bloom filters and Bloom filters.
To run these workflows, you have to setup an `conda` environment and install the package.


### Install the conda package manager (miniconda)
Go to https://docs.conda.io/en/latest/miniconda.html and download the Miniconda installer:
Choose Python 3.12 (or higher), your operating system, and preferably the 64 bit version.
Follow the instructions of the installer and append the `conda` executable to your PATH (even if the installer does not recommend it).
You can let the installer do it, or do it manually by editing your ``.bashrc`` or similar file under Linux or MacOS, or by editing the environment variables under Windows.
To verify that the installation works, open a new terminal and execute
```
conda --version # ideally 23.3.xx or higher
python --version # ideally 3.12.xx or higher
```

## BlowChoc installation
### Obtain BlowChoc
To obtain the software clone this public git repository with the command:
```
git clone https://gitlab.com/rahmannlab/blowchoc-filters
```


### Create and activate a conda environment
To run our software, a [conda](https://docs.conda.io/en/latest/) environment with the required libraries needs to be created.
A list of needed libraries is provided in the ``environment.yml`` file in the cloned repository;
it can be used to create a new environment:

```
cd blowchoc  # the directory of the cloned repository
conda env create
```
which will create an environment named ``blowchoc`` with the required dependencies,
using the provided ``environment.yml`` file in the same directory.

Setting up the environment may take some time, as conda searches and downloads packages.
After all dependencies are resolved, you activate the environment and install the package from the repository into this environment.
Make sure that you are in the root directory of the cloned repository (where this `README.md` file or the `CHANGELOG.md` file is) and run
```
conda activate blowchoc  # activate environment
pip install -e .  # install blowchoc package using pip
```


# Run the Snakemake example workflow

We provide multiple Snakemake workflows (used for the benchmarks in the paper), which creates all needed data files, builds all filters, computes the false positive rates, fill rates, etc. and tracks the used time.

To run one of these workflow, you will need space for the datasets and resulting filters.
Make sure you are in the working directory and that your conda environment called `blowchoc` is active.

Now the Snakemake workflow to benchmark the build times can be run as follows:
```bash
snakemake --cores 1 -s workflow_blowchoc/time_Snakefile -n  # dry-run: What will happen?
snakemake --cores 1 -s workflow_blowchoc/time_Snakefile # execute with 1 threads
```
The `-n` (or `--dry-run`) option first performs a dry run and prints out what will be done.
The `--cores 1` option uses 1 CPU cores to each job after the other, if you want to run multiple jobs in parallel you can adjust the cores accordingly.

This will run for quite some time (a big number of parameter combinations), best leave it overnight.
The results will appear in the `results/` directory. The resulting plots will be in the `plots/` folder.

We provide five different workflows:
* `time_Snakefile`: Benchmarks build time and query times for successful and unsuccessful lookups for all filter types.
* `costFunction_Snakefile`: Computes the false positive rate for all cost functions with different possible parameters.
* `overhead_Snakefile`: Computes the false positive rate for all filter types if the filters are dimensioned too large or too small.
* `block_histogram_Snakefile`: Computes the distribution of the fill per Block (set 1 bits) for the different cost functions with different choices.
* `species_Snakefile`: Benchmarks memory and time requirements for drosophila melanogaster, human and axolotl.

# Download Link for the reference genomes

* Drosophila melanogaster: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/215/GCF_000001215.4_Release_6_plus_ISO1_MT/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna.gz
* Human: https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz
* Axolotl: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/938/575/GCF_040938575.1_UKY_AmexF1_1/GCF_040938575.1_UKY_AmexF1_1_genomic.fna.gz
