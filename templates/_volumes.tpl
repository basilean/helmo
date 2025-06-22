{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Volume - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}
{{- define "volume.configMap" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
- name: {{ .name }}
  configMap:
    name: {{ $o.name }}
    defaultMode: 511
{{- end }}