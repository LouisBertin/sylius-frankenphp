<p align="center">
    <img alt="Sylius Logo" src="https://avatars.githubusercontent.com/u/719423?s=280&v=4" height="100">
    <img alt="FrankenPHP Logo" src="https://frankenphp.dev/img/dab.svg" height="100">
    <img alt="FrankenPHP Logo" src="https://training.galaxyproject.org/training-material/topics/admin/images/docker_whale.png" height="100">
</p>

<h1 align="center">Sylius + FrankenPHP + Docker</h1>

<p align="center">This is Sylius Standard Edition repository for starting new projects.</p>

## About
Sylius and a Docker config based on FrankenPHP

## Installation

**prerequisite**

- docker and docker compose : https://docs.docker.com/engine/install/

### Development
```bash
git clone git@github.com:LouisBertin/sylius-frankenphp.git
cd sylius-frankenphp
cp .env.dist .env - change "docker variables" section
make up
make install
```

⚠️ the `hostname` value is asked during the `make install` command. For development, typically use `localhost` as the hostname

### Production

**prerequisite**

- a domain name pointing to your server. Put the hostname value inside the `.env` Caddy will generate SSL certificate for you
- ssh access to your server
- docker and docker compose : https://docs.docker.com/engine/install/

```bash
git clone git@github.com:LouisBertin/sylius-frankenphp.git
cd sylius-frankenphp
cp .env.dist .env - change "docker variables" section
make up-prod
make install
```

⚠️ the `hostname` value is asked during the `make install` command

## More info

- The `deploy.sh.dist` script is available
