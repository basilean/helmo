{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  ConfigMap - Files

  context = . (context)
  options = Options for the object.
*/}}
{{- define "configMap.files" }}
apiVersion: v1
kind: ConfigMap
{{- include "metadata.all" . }}
data:
  {{- range $path := .options.files }}
  {{ regexSplit "/" $path -1 | last }}: |-
{{ (tpl ($.context.Files.Get $path) $) | indent 4 }}
  {{ end }}
{{- end }}