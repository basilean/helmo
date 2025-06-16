{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  Job - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "job.base" }}
kind: Job
apiVersion: batch/v1
metadata:
  name: {{ .name }}
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
      job-name: {{ .name }}      
  template:
    metadata:
      labels:
        job-name: {{ .name }}
    spec:
      dnsPolicy: ClusterFirst
      {{- if .options.containers }}
      containers:
        {{- range $container := .options.containers }}
          {{ include "container.base" (dict
            "context" .context
            "options" $container
          ) }}
        {{- end }}
      {{- end }}
      {{- if .options.volumes }}
      volumes:
        {{- range $volume := .options.volumes }}
          {{/* TODO: volume.base */}}
        {{- end }}
      {{- end }}
{{- end }}
