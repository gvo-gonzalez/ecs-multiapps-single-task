Create infraestructure with terraform

1.Install and configure awscli (required to upload images to ECR)
2.Install terraform
3.Install docker

Create terraform.tfvars file

cp terraform.tfvars.example terraform.tfvars

Configure terraform.tfvars variables

terraform init
terraform plan -out="out-put-file.out"
terraform apply "out-put-file.out"

Login to AWS Route53 and configure domains pointing to the loadbanceler created

Configure nginx virtual hosts

    Edit file Nginx/conf/nodejsapp.conf

        1. Change server_name value and if required proxy_pass variable that points to your backend nodejs server

# WARNING!!! Backend name MUST BE the same as defined in "nodecontainer_name" variable in terraform.tfvars  file
    
    Edit file Nginx/conf/phpapp.conf

        2. Change server_name value and if required fastcgi_pass variable that points to your backend php-fpm server

# WARNING!!! fastcgi_pass name MUST BE the same as defined in "nginx_fastcgi_app" variable in terraform.tfvars  file

mkdir DockerEnv/appstack

# Change your repository here
git clone https://github.com/user-or-company/your-laravel-app.git DockerEnv/appstack/phpapp

create or copy your .env file into appstack/phpapp directory so it will be included in the build process

docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/example-laravel:TAG_NUM -f DockerEnv/Laravel/Dockerfile DockerEnv/appstack/phpapp/.

# Change your repository here
git clone https://github.com/user-or-company/your-nodejs-app.git DockerEnv/appstack/nodejsapp

docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/example-nodejs:TAG_NUM -f DockerEnv/NodeJS/Dockerfile DockerEnv/appstack/nodejsapp/.

docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/nginx-proxy:TAG_NUM -f DockerEnv/Nginx/Dockerfile DockerEnv/.

`aws ecr get-login --no-include-email`

docker push aws_account_id.dkr.ecr.region.amazonaws.com/example-laravel:TAG_NUM
docker push docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/example-nodejs:TAG_NUM
docker push docker build -t aws_account_id.dkr.ecr.region.amazonaws.com/nginx-proxy:TAG_NUM