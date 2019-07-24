# Install R version 3.5
FROM rocker/shiny-verse:latest
#FROM rocker/geospatial

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev 

# Add shiny user
#RUN groupadd  shiny \
#&& useradd --gid shiny --shell /bin/bash --create-home shiny

# Install R packages that are required
# TODO: add further package if you need!
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('googleVis', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('DT', repos='http://cran.rstudio.com/')"


# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY /app /srv/shiny-server/

# Make the ShinyApp available at port 3838
EXPOSE 80

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

COPY shiny-server.sh /usr/bin/shiny-server.sh

# run app
CMD ["/usr/bin/shiny-server.sh"]