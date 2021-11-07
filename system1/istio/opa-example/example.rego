# package example

# greeting = msg {
#     info := opa.runtime()
#     hostname := info.env["HOSTNAME"] # Kubernetes sets the HOSTNAME environment variable.
#     msg := sprintf("hello from pod %q!", [hostname])
# }
package envoy.authz

import input.attributes.request.http as http_request

default allow = true
token = {"valid": valid, "payload": payload} {
    [_, encoded] := split(http_request.headers.authorization, " ")
    [valid, _, payload] := io.jwt.decode_verify(encoded, {"secret": "secret"})
}

allow {
    is_token_valid
    action_allowed
}

is_token_valid {
  token.valid
  now := time.now_ns() / 1000000000
  token.payload.nbf <= now
  now < token.payload.exp
}

action_allowed {
  startswith(http_request.path, base64url.decode(token.payload.path))
}
