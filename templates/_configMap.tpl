{{/*

  configMap - Files

  ctx = . (context)
  name = Name of the object.
  files = List of file paths.

*/}}

{{- define "configMap.files" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" .ctx | indent 4 }}
data:
  {{- range $path := .files }}
  {{ $path }}: |-
{{ (tpl ($.ctx.Files.Get $path) $) | indent 4 }}
  {{ end }}
{{- end }}
