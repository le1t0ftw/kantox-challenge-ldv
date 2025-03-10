Kantox Challenge - DevOps

Introducción

Este proyecto es parte de un challenge técnico para una posición de Cloud Engineer / DevOps. La aplicación está diseñada para ejecutarse en un entorno local de Kubernetes utilizando Minikube.

Requisitos

Para ejecutar este proyecto en un ambiente local, necesitas contar con una cuenta de AWS, la cual servirá para el despliegue de la infraestructura con Terraform y para almacenar las imágenes que serán creadas por el pipeline.

Además, se requieren las siguientes herramientas:

Minikube

Argo CD

Kubectl

Helm

Docker

Terraform

Instalación y Configuración

1. Iniciar Minikube

minikube start --memory=4g --cpus=2

2. Instalar y configurar el plugin para autenticación con AWS ECR

Para poder extraer imágenes desde Amazon ECR, se debe instalar y configurar el complemento registry-creds en Minikube. Este complemento permite que los nodos del clúster obtengan credenciales de autenticación automáticamente para acceder a los registros privados de contenedores.

Nota: Minikube no soporta ServiceAccount con AWS, por lo que es necesario utilizar este complemento para la autenticación con ECR.

Habilitar el complemento

minikube addons enable registry-creds

Configurar el complemento para AWS

minikube addons configure registry-creds

Durante la configuración, se te pedirá seleccionar un proveedor de registro. Debes elegir aws e ingresar la información requerida:

AWS_ACCESS_KEY_ID: Clave de acceso de AWS

AWS_SECRET_ACCESS_KEY: Clave secreta de AWS

AWS_ACCOUNT_ID: ID de la cuenta de AWS

Verificar la configuración

kubectl get secrets -n kube-system | grep registry-creds

Si ves un secreto con el prefijo registry-creds, significa que la configuración fue exitosa.

Despliegue de Infraestructura con Terraform

Antes de desplegar las aplicaciones en Kubernetes, es necesario desplegar la infraestructura en AWS utilizando Terraform. Esta infraestructura es fundamental, ya que proporcionará los recursos necesarios para que la aplicación diseñada en Python pueda realizar las consultas adecuadas. Para este challenge, el statefile de Terraform se conservará de manera local.

Descripción de la Infraestructura

La infraestructura provisionada con Terraform incluye los siguientes recursos en AWS:

Amazon S3: Un bucket para almacenar archivos estáticos o logs.

IAM Roles y Policies: Permisos adecuados para que los servicios puedan interactuar entre sí de manera segura.

Amazon Parameter Store: Un servicio de AWS Systems Manager utilizado para almacenar valores sensibles y configuraciones, como credenciales de bases de datos y claves API, de manera segura.

1. Inicializar Terraform

cd terraform
terraform init

2. Planificar la infraestructura

terraform plan

Esto mostrará los recursos que se crearán en AWS.

3. Aplicar la infraestructura

terraform apply -auto-approve

Una vez finalizado el despliegue de la infraestructura, se puede proceder con la configuración y despliegue de las aplicaciones.

CI/CD

Configuración Inicial

Para utilizar este repositorio correctamente, es necesario realizar un fork del mismo en tu cuenta de GitHub y configurar los secrets correspondientes para la cuenta de AWS en GitHub Actions.

Los secrets necesarios son:

AWS_ACCESS_KEY_ID: Clave de acceso de AWS

AWS_SECRET_ACCESS_KEY: Clave secreta de AWS

AWS_ACCOUNT_ID: ID de la cuenta de AWS

Estos valores deben configurarse en la sección de Settings > Secrets and variables > Actions de tu fork en GitHub.

Estructura del Repositorio

/
|-- main-api/               # Microservicio principal
|-- auxiliary-service/      # Microservicio auxiliar
|-- k8s/                    # Manifiestos de Kubernetes
|-- terraform/              # Infraestructura como código
|-- .github/workflows/      # Pipelines de CI/CD
|-- README.md               # Documentación

Pasos del Pipeline

Validación del Código

Construcción y Test de la Aplicación

Construcción de Imágenes Docker

Push de Imágenes a AWS ECR

Despliegue de Infraestructura con Terraform

Aplicación de los Manifiestos de Kubernetes

Verificación del Despliegue

Despliegue con Argo CD

Este proyecto utiliza Argo CD para el despliegue en Kubernetes. Para instalarlo y sincronizar la aplicación:

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Agregar el repositorio de GitHub a Argo CD

Generar una clave SSH

Agregar la clave pública a GitHub

Configurar Argo CD para usar la clave SSH

Verificar que el repositorio fue agregado correctamente

Desplegar las aplicaciones en Argo CD

kubectl apply -f kubernetes/argo-deploy.yaml

Componentes Desplegados

Main API: Servicio principal.

Auxiliary Service: Servicio auxiliar.

Grafana y Prometheus: Monitoreo del sistema y métricas.

Luego, sincroniza la aplicación desde Argo CD.

Prueba de la Aplicación Main API

Una vez finalizado el despliegue, puedes probar el funcionamiento de main-api siguiendo estos pasos:

Obtener la URL del servicio en Minikube:

minikube service main-api --url

Esto devolverá una URL similar a http://192.168.49.2:30080.

Realizar una petición a la API:

curl -X GET http://192.168.49.2:30080/health

Esto verificará si la API está corriendo correctamente.

Ejecutar una consulta de prueba:

curl -X GET http://192.168.49.2:30080/api/v1/resource

Sustituye /api/v1/resource por el endpoint real que desees probar.

Si la API responde correctamente, significa que el despliegue ha sido exitoso y la infraestructura está funcionando como se espera.

