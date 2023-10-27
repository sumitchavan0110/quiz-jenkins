FROM python:3.9

 

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

 

WORKDIR /Quiz-app-django

 

COPY requirements.txt /Quiz-app-django/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

 

COPY . /Quiz-app-django/

 

EXPOSE 8000

 

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]