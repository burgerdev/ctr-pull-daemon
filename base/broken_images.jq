[
  .items[] | 
  # only our own RuntimeClasses
  select(.spec.runtimeClassName | (. and startswith("contrast-"))) |
  # Combine info from spec and status per container
  [ 
    .spec.nodeName as $podNode |
    .spec.runtimeClassName as $rc |
    [.spec.containers[] | {name: .name, image: .image, node: $podNode, runtimeClass: $rc}],
    [.status.containerStatuses[] | {name: .name, ready: .ready}]
  ] |
  flatten |
  group_by(.name) |
  map(add) |
  # Filter for local pods
  map(select(.node == $node)) |
  # Filter for unready containers
  map(select(.ready | not))
] | flatten | .[]