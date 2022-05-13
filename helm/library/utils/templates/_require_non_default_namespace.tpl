{{- define "utils.requireNonDefaultNamespace" -}}
{{- if ne .Release.Namespace "default"}}
namespace: {{ required "Release.Namespace is required is required" .Release.Namespace }}
{{- else -}}
{{- fail "Namespace default is not allowed, set via --namespace=<namespace> (e.g. canary)" }}
{{- end}}
{{- end}}
