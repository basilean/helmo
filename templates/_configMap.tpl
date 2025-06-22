{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  configMap - Files

  context = . (context)
  options = Options for the object.
*/}}

{{- define "configMap.files" }}
{{- $o := .options -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $o.name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
data:
  {{- range $path := $o.files }}
  {{ regexSplit "/" $path -1 | last }}: |-
{{ (tpl ($.context.Files.Get $path) $) | indent 4 }}
  {{ end }}
{{- end }}
