FROM julia:latest

# user
RUN useradd --create-home --shell /bin/bash genie

# app
RUN mkdir /home/genie/app
COPY . /home/genie/app
WORKDIR /home/genie/app

RUN chown genie:genie -R *

RUN chmod +x bin/repl
RUN chmod +x bin/server
RUN chmod +x bin/serverinteractive
RUN chmod +x bin/runtask

USER genie

RUN julia -e "using Pkg; Pkg.activate(\".\"); Pkg.instantiate(); Pkg.precompile(); "

CMD ["bin/server"]
