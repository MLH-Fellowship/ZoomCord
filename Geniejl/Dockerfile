FROM julia:latest

# user
RUN useradd --create-home --shell /bin/bash genie

# app
RUN mkdir /Geniejl
WORKDIR /Geniejl

RUN julia -e "using Pkg; Pkg.activate(\".\"); Pkg.resolve(); Pkg.instantiate(); Pkg.precompile(); "

