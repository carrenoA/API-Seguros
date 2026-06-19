# Imagen base ligera de Python
FROM python:3.12-slim

# Evita que Python genere archivos .pyc (.pyc = código compilado, no necesario en contenedores)
ENV PYTHONDONTWRITEBYTECODE=1
# Asegura que la salida de los logs se envíe directamente al terminal (evita problemas de buffering)
ENV PYTHONUNBUFFERED=1

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalamos las dependencias
# Nota: Debes tener un archivo requirements.txt en la raíz con tus librerías (django, djangorestframework, etc.)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos todo el código fuente del proyecto al contenedor
COPY . .

# Exponemos el puerto donde correrá Django
EXPOSE 8000

# Comando para iniciar la aplicación (usamos runserver para desarrollo, pero en producción usarías gunicorn/daphne)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]