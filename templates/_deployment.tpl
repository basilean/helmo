{{/*

  Deployment - Base

  ctx = . (context)
  name = Name of the object.
  opt = Options for the object.

*/}}

{{- define "deployment.base" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" .ctx | indent 4 }}
spec:
  replicas: {{ default
    .ctx.Values.global.opt.replicas
    .opt.replicas
  }}
  revisionHistoryLimit: {{ default
    .ctx.Values.global.opt.revisionHistoryLimit
    .opt.revisionHistoryLimit
  }}
  strategy:
    {{- toYaml (default .ctx.Values.global.opt.strategy .opt.strategy) | nindent 4 }}
  selector:
    matchLabels:
      app.kubernetes.io/template: {{ .name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/template: {{ .name }}
        {{- include "labels.all" .ctx | indent 8 }}
      {{- if .opt.annotations }}
      annotations:
        {{- toYaml .opt.annotations | nindent 6 }}
      {{ end }}
    spec:
    {{- if .opt.volumes }}
      {{- with .opt.volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
    {{- with (default .ctx.Values.global.opt.imagePullSecrets .opt.imagePullSecrets) }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      containers:
        - name: {{ .name | quote }}
          image: {{ (printf "%s:%s" 
            (default .ctx.Values.global.opt.image .opt.image)
            (default .ctx.Values.global.opt.version .opt.version) 
          ) | quote }}
          imagePullPolicy: {{ (default
            .ctx.Values.global.opt.imagePullPolicy
            .opt.imagePullPolicy
          ) | quote }}
          {{- include "container.resources" (default 
            .ctx.Values.global.opt.resources
            .opt.resources
          ) | nindent 10 }}
          {{- if .opt.ports }}
          ports:
            {{- toYaml .opt.ports | nindent 12 }}
          {{- end }}
          {{- if .opt.volumeMounts }}
          volumeMounts:
            {{- toYaml .opt.volumeMounts | nindent 12 }}
          {{- end }}
{{- end }}
