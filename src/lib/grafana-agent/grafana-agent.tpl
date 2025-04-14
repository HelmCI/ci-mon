{{- $s := .Release.Store }}
{{- $r    := $s.registry }}

{{- with $r.hostProxy }}
image:
  registry: {{ . }}/{{ $r.proxy.docker }}
configReloader:
  image:
    registry: {{ . }}/{{ $r.proxy.ghcr_io }}
{{- end }}

agent:
  extraPorts:
    - name: otlp-grpc
      port: 4317
      targetPort: 4317
      protocol: TCP
  configMap:
    create: true
    content: |-
      otelcol.receiver.otlp "otlp_receiver" {
        grpc {
          endpoint = "0.0.0.0:4317"
        }
        output {
          traces = [
            otelcol.exporter.otlp.tempo.input,
          ]
        }
      }
      otelcol.exporter.otlp "tempo" {
          client {
              endpoint = "http://tempo:4317"
              tls {
                  insecure = true
                  insecure_skip_verify = true
              }
          }
      }
