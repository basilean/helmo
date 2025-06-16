{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  configMap - Files

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "configMap.files" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
data:
  {{- range $path := .options.files }}
  {{ $path }}: |-
{{ (tpl ($.context.Files.Get $path) $) | indent 4 }}
  {{ end }}
{{- end }}
