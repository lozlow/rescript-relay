exception Graphql_error(string)

let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "http://graphql/",
    {
      method: #POST,
      body: {"query": operation.text, "variables": variables}
      ->Js.Json.stringifyAny
      ->Belt.Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
      }),
    },
  )

  if Response.ok(resp) {
    await Response.json(resp)
  } else {
    raise(Graphql_error("Request failed: " ++ Response.statusText(resp)))
  }
}
