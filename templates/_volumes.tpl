{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Volume - Auto

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "volume.auto" -}}
- name: {{ .name }}
{{- if .options.configMap }}
{{- include "volume.configMap" . }}
{{- else if .options.secret }}
{{- else if .options.emptyDir }}
{{- else if .options.persistentVolumeClaim }}
{{- else if .options.Directory }}
{{- else if .options.nfs }}
{{- else if .options.projected }}
{{- else if .options.downwardAPI }}
{{- else }}
{{- end }}
{{- end }}

{{/*
  volume.configMap
*/}}
{{- define "volume.configMap" }}
{{- $d := .context.Values.global.options.volume.configMap }}
{{- $o := .options.configMap }}
  configMap:
    name: {{ $o.name }}
  {{- if (or $d.defaultMode $o.defaultMode) }}
    defaultMode: {{ default $d.defaultMode $o.defaultMode | quote }}
  {{- end }}
{{- end }}

{{/*
  volume.mount
*/}}
{{- define "volume.mount" }}
{{- $d := .context.Values.global.options }}
{{- $o := .options -}}
- name: {{ .name }}
  mountPath: {{ $o.path }}
  readOnly: {{ $o.ro }}
{{- end }}
