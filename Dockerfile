FROM elixir:1.18
RUN mkdir /home/app
RUN mkdir /home/app/project
WORKDIR /home/app/project

# Install the application dependencies
# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
# COPY src ./src
EXPOSE 5000

# Setup an app  user so the container doesn't run as the root user
RUN useradd app
RUN chown app /home/app
USER app

CMD ["/bin/bash"]