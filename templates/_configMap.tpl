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
  
  TODO: ConfigMap names must follow DNS label format
    * Only lowercase alphanumeric characters (a-z, 0-9), -, and . are allowed.
    * Must start and end with an alphanumeric character.
    * Max length: 253 characters.
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
  {{ regexSplit "/" $path -1 | last }}: |-
{{ (tpl ($.context.Files.Get $path) $) | indent 4 }}
  {{ end }}
{{- end }}
