{{/*
Inspired by: https://stackoverflow.com/a/67523275
Returns a secret if it already in Kubernetes, otherwise it creates it with default values.
Input is a dict with the following entries:
- Namespace: Usually the Namespace of the Release
- Kind: Secret
- Name: Name of the secret to get or create
- Keys: Keys to create in secret if it didn't exist (note, the valus are just the key names as base64
*/}}
{{- define "utils.getOrCreateInitialSecret" -}}
{{- $keys := required "Dict Entry KEYS is required to set initial secret keys" .KEYS | trim | split ","  -}}
{{- include "utils.getOrCreateInitialSecretFromArray" (merge $  (dict "KEYS_ARRAY" $keys))  -}}
{{- end -}}
