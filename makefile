create-cluster:
	k3d cluster create dev --config ./kubernetes/k3d-cluster.config.yaml

start-cluster:
	k3d cluster start dev

stop-cluster:
	k3d cluster stop dev

delete-cluster:
	k3d cluster delete dev