# System Components

## Envoy Building Blocks

- Listeners
- Routes
- Clusters
- Endpoints

### Filters

- Listener filters
  - Initial connection phase (L4)
- Network filters
  - Raw Data (L4)
  - HTTP Connection Manager (HCM)
- HTTP filters
  - HTTP requests and responses (L7)

#### HTTP filters

- Interact with requests/responses
- Not coupled with envoy
- Filters are chained

#### Wasm in Envoy

WASM is portable binary, executed in a sandbox environment (VM)
Envoy uses a subset of v8 virtual machine, used in node and chrome. Wasm VM is loaded.wasm module
Using multi-thread model, with main and worker threads which are independent

Execution can be stateless or stateful

- Stateless, does not communicate with other threads

  - HTTP filters
  - Network filters

- Stateful, able to aggregate data from multiple requests (worker threads)
  - Wasm service

Proxy-Wasm

- Application Binary Interface (ABI) standard
  - functions and callbacks (GetHttpResponseBody, SendHttpResponse ...)
- Proxy-agnostic (example: MOSN)

Proxy-Wasm SDKs

### Dynamic Configuration

Discovery Services (xDS)

- CDS
- EDS
- LDS
- RDS
- SDS

gRPC or REST endpoints

## Istio Security
