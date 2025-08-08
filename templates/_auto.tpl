{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
	Auto - All

*/}}
{{- define "auto.all" }}
{{- $context := . }}
{{- range $object, $list := .Values }}
{{- if not (or (eq $object "global") (eq $object "enabled")) }}
  {{- range $name, $options := $list }}
  {{- $helper := printf "%s.%s" $object "auto" }}
  {{- $arguments := dict "context" $context "name" $name "options" $options }}
{{ include $helper $arguments }}
---
{{- end }}
{{- end }}
{{- end }}
{{- end }}