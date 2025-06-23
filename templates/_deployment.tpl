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

  Must support rolling updates, restartPolicy: Always
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
{{- include "pod.base" . | indent 4}}
{{- end }}
