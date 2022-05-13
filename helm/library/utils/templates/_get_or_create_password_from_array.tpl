{{/*
Inspired by: https://stackoverflow.com/a/67523275
Returns a secret if it already in Kubernetes, otherwise it creates it with default values.
Input is a dict with the following entries:
- Namespace: Usually the Namespace of the Release
- Kind: Secret
- Name: Name of the secret to get or create
- KEYS_ARRAY: A list of Keys to create in secret if it didn't exist (note, the valus are just the key names as base64)
*/}}
{{- define "utils.getOrCreateInitialSecretFromArray" -}}
{{- $secret := (lookup "v1" (.Kind | trim) (.Namespace | trim) (.Name | trim)) -}}
{{- $keys := required "Dict Entry KEYS_ARRAY is required to set initial secret keys" .KEYS_ARRAY -}}
{{- if $secret.data -}}
{{- range $key, $value := $secret.data }}
{{ $key |  indent 2 }}: {{ $value }}
{{- end -}}
{{- else -}}
{{- range $keyName := $keys }}
{{ $keyName | trim | indent 2 }}: {{ $keyName | trim | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}
