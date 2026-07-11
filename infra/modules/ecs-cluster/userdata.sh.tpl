#!/bin/bash

cat <<EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
ECS_ENABLE_CONTAINER_METADATA=true
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
ECS_LOGLEVEL=info
EOF


systemctl enable ecs
systemctl start ecs

systemctl enable docker
systemctl start docker

systemctl enable ecs
systemctl restart ecs