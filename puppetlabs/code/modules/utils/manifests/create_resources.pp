define utils::create_resources(
  $resource,
  $params
) {
  if defined($resource) {
    notify { "running ${resource} with ${params}": }
    create_resources($resource, $params)
  }
  else {
    fail("resource '${resource}' is not defined!")
  }
}