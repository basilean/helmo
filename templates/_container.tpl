{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  Container - Base

*/}}
{{- define "container.base" }}
name: {{ .name | quote }}
image: {{ (printf "%s/%s:%s" 
  (default .ctx.Values.global.opt.registry .opt.registry)
  (default .ctx.Values.global.opt.path .opt.path)
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



{{/*

  Container - Limits

*/}}
{{- define "container.limits" }}
{{- if .cpu }}
cpu: {{ .cpu }}
{{- end }}
{{- if .memory }}
memory: {{ .memory }}
{{- end }}
{{- end }}


{{/*

  Container - Resources

*/}}
{{- define "container.resources" }}
{{- if (or .request .limits) -}}
resources:
  {{- if .request }}
  request:
    {{- include "container.limits" .request | indent 4 }}
  {{- end }}
  {{- if .limits }}
  limits:
    {{- include "container.limits" .limits | indent 4 }}
  {{- end }}
{{- end }}
{{- end }}


{{/*

  Container - Environment

*/}}
{{- define "container.environment" }}
{{- if gt (len .) 0 -}}
{{- range . }}
- name: {{ .name }}
  {{- if .valueFrom }}
  valueFrom:
    {{- include "container.env.valueFrom" .valueFrom | indent 6 }}
  {{- else }}
  value: "{{ .value }}"
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
