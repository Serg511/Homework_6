[load_balancer_servers]
lb-0 ansible_host=${lb-0-ip} priority=101 state=MASTER
lb-1 ansible_host=${lb-1-ip} priority=100 state=BACKUP

[db_server]
db-0 ansible_host=${db-0-ip} etcd_name=etcd0 priority=102 state=MASTER unicast_peer1=${db-1-ip0} unicast_peer2=${db-2-ip0}
db-1 ansible_host=${db-1-ip} etcd_name=etcd1 priority=101 state=BACKUP unicast_peer1=${db-0-ip0} unicast_peer2=${db-2-ip0}
db-2 ansible_host=${db-2-ip} etcd_name=etcd2 priority=100 state=BACKUP unicast_peer1=${db-0-ip0} unicast_peer2=${db-1-ip0}

[web_servers]
web-0 ansible_host=${web-0-ip}
web-1 ansible_host=${web-1-ip}
web-2 ansible_host=${web-2-ip}

[iscsi]
iscsi-0 ansible_host=${iscsi-0-ip}