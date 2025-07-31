{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
	Metadata - All

*/}}
{{- define "metadata.all" }}
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
{{- end }}

{{/*
	Labels - All

*/}}
{{- define "labels.all" }}
app.kubernetes.io/name: {{ .context.Chart.Name | quote }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
app.kubernetes.io/instance: {{ .context.Values.global.instance | quote }}
app.kubernetes.io/part-of: {{ .context.Values.global.project | quote }}
app.kubernetes.io/organization: {{ .context.Values.global.organization | quote }}
app.kubernetes.io/managed-by: "helm"
environment: {{ .context.Values.global.environment | quote }}
{{- if .context.Values.global.labels }}
{{- include "keys.quote" .context.Values.global.labels }}
{{- end }}
{{- if .context.Values.labels }}
{{- include "keys.quote" .context.Values.labels }}
{{- end }}
{{- if and .options .options.labels }}
{{- include "keys.quote" .options.labels }}
{{- end }}
{{- end }}

{{/*
	Annotations - All

*/}}
{{- define "annotations.all" }}
{{- if .context.Values.global.annotations }}
{{- include "keys.quote" .context.Values.global.annotations }}
{{- end }}
{{- if .context.Values.annotations }}
{{- include "keys.quote" .context.Values.annotations }}
{{- end }}
{{- if and .options .options.annotations }}
{{- include "keys.quote" .options.annotations }}
{{- end }}
{{- end }}

{{/*
	Keys - Quote

*/}}
{{- define "keys.quote" }}
  {{- range $key, $val := . }}
{{ $key }}: {{ $val | quote }}
  {{- end }}
{{- end }}

{{/*
	Keys - B64

*/}}
{{- define "keys.b64" }}
  {{- range $key, $val := . }}
{{ $key }}: {{ $val | b64enc }}
  {{- end }}
{{- end }}
