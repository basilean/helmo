{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  Deployment - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "deployment.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
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
      containers:
        - name: {{ .name | quote }}
          image: {{ (printf "%s/%s:%s"
            (default $d.image.registry $o.image.registry)
            (default $d.image.path $o.image.path)
            (default $d.image.version $o.image.version) 
          ) | quote }}
          imagePullPolicy: {{ (
            default $d.imagePullPolicy $o.imagePullPolicy
          ) | quote }}
          {{- include "container.resources" (default 
            $d.resources
            $o.resources
          ) | nindent 10 }}
          {{- if $o.ports }}
          ports:
            {{- toYaml $o.ports | nindent 12 }}
          {{- end }}
          {{- if $o.volumeMounts }}
          volumeMounts:
            {{- toYaml $o.volumeMounts | nindent 12 }}
          {{- end }}
{{- end }}
