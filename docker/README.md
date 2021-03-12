### Skopi
(the following needs to be checked; tagging was done a posteriori for now)
```bash
python create-container.py -b yaml/ana-4.0.17-py3.yml -a yaml/skopi.yml -o skopi-ana.yml -d -r slaclcls -t skopi-ana -v 0.5.1-4.0.17-py3
docker push slaclcls/skopi-ana:0.5.1-4.0.17-py30.5.1-4.0.17-py3
docker tag slaclcls/skopi-ana:0.5.1-4.0.17-py3 slaclcls/skopi-ana:latest
docker push slaclcls/skopi-ana:latest
```

### Dragonfly
```bash
docker build -f docker/Dockerfile.dragonfly -t slaclcls/dragonfly-ana:4.0.17 docker
docker push slaclcls/dragonfly-ana:4.0.17
docker tag laclcls/dragonfly-ana:4.0.17 slaclcls/dragonfly-ana:latest
docker push slaclcls/dragonfly-ana:latest
```
