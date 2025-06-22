{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Deployment - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "deployment.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
apiVersion: apps/v1
kind: Deployment
{{- include "metadata.all" . }}
spec:
  replicas: {{ default
    $d.replicas
    $o.replicas
  }}
  revisionHistoryLimit: {{ default
    $d.revisionHistoryLimit
    $o.revisionHistoryLimit
  }}
  strategy:
    {{- toYaml (default $d.strategy $o.strategy) | nindent 4 }}
  selector:
    matchLabels:
      app.kubernetes.io/template: {{ .name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/template: {{ .name }}
        {{- include "labels.all" . | indent 8 }}
      annotations:
        {{- include "annotations.all" .| indent 8 }}
    spec:
    {{- if $o.volumes }}
      {{- with $o.volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
    {{- with (default $d.imagePullSecrets $o.imagePullSecrets) }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      {{- if .options.containers }}
      containers:
        {{- range $name, $options := .options.containers }}
{{ include "container.base" (dict "context" $.context "name" $name "options" $options) | indent 8 }}
        {{- end }}
      {{- end }}
{{- end }}
