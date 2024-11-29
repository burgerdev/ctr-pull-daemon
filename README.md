# ctr-pull-daemon

The daemon watches pods for failed containers and attempts to pull the container image with containerd.
This is a workaround for https://github.com/containerd/containerd/issues/8674.

## How does it work?

1. [`daemonset.yaml`](base/daemonset.yaml) runs a process on every node.
2. The [`entrypoint.sh`](base/entrypoint.sh) runs a poor man's reconciliation loop.
3. `reconcile` in [`functions.sh`](base/functions.sh) loops over all pods, filters for relevant pods and pulls the image.
4. The filter is expressed in [`broken_images.jq`](base/broken_images.jq). It's overly broad and should be narrowed down to only relevant pod failures.

## How to install

On a normal containerd installation:

```sh
kubectl apply -k base
```

On k3s:

```sh
kubectl apply -k k3s
```
