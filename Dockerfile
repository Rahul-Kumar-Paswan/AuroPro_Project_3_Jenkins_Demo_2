FROM python
COPY . /app
WORKDIR /app
RUN python setup.py sdist bdist_wheel
RUN pip install -r requirements.txt
RUN pip install dist/flask_app-*.tar.gz  
RUN pip install dist/flask_app-*.whl  
EXPOSE  5000
# Define environment variables
ENV MYSQL_HOST=$MYSQL_HOST
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
ENV MYSQL_DATABASE=$MYSQL_DATABASE
CMD ["python", "-m" ,"app"]

# docker run -p 5000:5000 \
#   -e MYSQL_HOST=<your_rds_endpoint> \
#   -e MYSQL_USER=<your_database_user> \
#   -e MYSQL_ROOT_PASSWORD=<your_database_password> \
#   -e MYSQL_DATABASE=<your_database_name> \
#   your_image_name:your_tag