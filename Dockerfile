FROM registry.access.redhat.com/ubi8/python-39:1

WORKDIR /opt/app-root/src

COPY Pipfile* /opt/app-root/src/

## NOTE - rhel enforces user container permissions stronger ##
USER root

RUN yum -y install graphviz

RUN pip3 install --upgrade pip==21.3.1 \
  && pip3 install --upgrade pipenv==2020.11.15 \
  && pipenv install --deploy

RUN pipenv lock -r > requirements.txt && pip3 install -r requirements.txt

USER 1001

COPY . /opt/app-root/src
ENV FLASK_APP=server/__init__.py
ENV PORT 3002

EXPOSE 3002

CMD ["python3", "manage.py", "start"]
