{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Job - Base

  context = . (context)
  options = Options for the object.
*/}}
{{- define "job.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
kind: Job
apiVersion: batch/v1
metadata:
  name: {{ $o.name }}
  labels:
{{- include "labels.all" . | indent 4 }}
  annotations:
{{- include "annotations.all" . | indent 4 }}
spec:
  parallelism: 1
  completions: 1
  backoffLimit: 2
  completionMode: NonIndexed
  suspend: false
  selector:
    matchLabels:
      job-name: {{ $o.name }}      
  template:
    metadata:
      labels:
        job-name: {{ $o.name }}
{{- include "labels.all" . | indent 8 }}
      annotations:
{{- include "annotations.all" . | indent 8 }}
    spec:
      dnsPolicy: ClusterFirst
      {{- if .options.initContainers }}
      initContainers:
        {{- range $container := .options.initContainers }}
{{ include "container.base" (dict "context" $.context "options" $container) | indent 8 }}
        {{- end }}
      {{- end }}
      {{- if .options.containers }}
      containers:
        {{- range $container := .options.containers }}
{{ include "container.base" (dict "context" $.context "options" $container) | indent 8 }}
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
