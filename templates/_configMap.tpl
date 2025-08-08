{{/* configMap */}}

{{- define "configMap.auto" -}}
apiVersion: v1
kind: ConfigMap
{{- include "metadata.all" . }}
{{- if .options.keys }}
data:
{{- include "keys.quote" .options.keys | indent 2 }}
{{- else if .options.files }}
data:
{{- include "configMap.files" . }}
{{- else if .options.binary }}
binaryData:
{{- include "configMap.binary" . }}
{{- else }}
{{- end }}
{{- end }}

{{- define "configMap.files" }}
{{- range $path := .options.files }}
  {{ regexSplit "/" $path -1 | last }}: |-
{{ (tpl ($.context.Files.Get $path) $) | indent 4 }}
{{ end }}
{{- end }}

{{- define "configMap.binary" }}
{{- range $path := .options.binary }}
  {{ regexSplit "/" $path -1 | last }}: {{ $.context.Files.Get $path | b64enc }}
{{ end }}
{{- end }}