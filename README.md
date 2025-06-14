# Actividad 3: ELK con Apollo Server

Esta actividad está dividida en las siguientes carpetas:

## aws-apollo
Contiene el despliegue individual de Apollo Server. 

Se puede desplegar un contenedor en local:
```
cd aws-apollo
docker-compose build
docker-compose up -d
```

Se puede crear la imagen en AWS:


```
# Validación en AWS
./set-aws-creds.ps1

# Construcción de la imagen
packer init .
packer build .
```

## dc-elk
Construye el stack ELK en local con docker-compose
```
cd dc-elk
docker-compose build
docker-compose up -d
```


## dc-elk
Construye el stack ELK y el servidor Apollo en local con docker-compose
```
cd dc-elk-apollo
docker-compose build
docker-compose up -d
```


