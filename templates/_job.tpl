{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Job - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "job.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
kind: Job
apiVersion: batch/v1
{{- include "metadata.all" . }}
spec:
  parallelism: 1
  completions: 1
  backoffLimit: 2
  completionMode: NonIndexed
  suspend: false
  selector:
    matchLabels:
      job-name: {{ .name }}      
  template:
    metadata:
      labels:
        job-name: {{ .name }}
{{- include "labels.all" . | indent 8 }}
      annotations:
{{- include "annotations.all" . | indent 8 }}
    spec:
      dnsPolicy: ClusterFirst
      {{- if .options.containers }}
      containers:
        {{- range $name, $options := .options.containers }}
{{ include "container.base" (dict "context" $.context "name" $name "options" $options) | indent 8 }}
        {{- end }}
      {{- end }}
      {{- if .options.volumes }}
      volumes:
        {{- range $volume := .options.volumes }}
{{ include "volume.configMap" (dict "context" $.context "name" $volume.name "options" $volume.configMap) | indent 8 }}
          {{/* TODO: volume.base */}}
        {{- end }}
      {{- end }}
{{- end }}
