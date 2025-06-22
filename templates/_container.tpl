{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Container - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "container.base" }}
{{- $d := .context.Values.global.options -}}
{{- $o := .options -}}
- name: {{ .name | quote }}
  {{- $image := (default dict $o.image) }}
  image: {{ (printf "%s/%s:%s"
  (default $d.image.registry $image.registry)
  (default $d.image.path $image.path)
  (default $d.image.version $image.version) 
) | quote }}
  {{- if (or $d.workingDir $o.workingDir) }}
  workingDir: {{ (default $d.workingDir $o.workingDir) | quote }}
  {{- end}}
  {{- if $o.args }}
  args:
    {{- range $arg := $o.args }}
    - {{ $arg | quote }}
    {{- end}}
  {{- end}}
  {{- if (or $d.imagePullPolicy $o.imagePullPolicy) }}
  imagePullPolicy: {{ (default
  $d.imagePullPolicy
  $o.imagePullPolicy
) | quote }}
  {{- end}}
  {{- if (or $d.resources $o.resources) }}
  {{- $resources := default dict $o.resources }}
  resources:
    {{- $request := (default dict $resources.request) }}
    request:
      cpu: {{ (default $d.resources.request.cpu $request.cpu | quote) }}
      memory: {{ (default $d.resources.request.memory $request.memory | quote) }}
    {{- $limits := (default dict $resources.limits) }}
    limits:
      cpu: {{ (default $d.resources.limits.cpu $limits.cpu | quote) }}
      memory: {{ (default $d.resources.limits.memory $limits.memory | quote) }}
  {{- end}}
{{- if $o.ports }}
  ports:
  {{- toYaml $o.ports | nindent 4 }}
{{- end }}
{{- if $o.volumeMounts }}
  volumeMounts:
  {{- toYaml $o.volumeMounts | nindent 4 }}
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

{{- include "container.resources" (default 
  $d.resources
  $o.resources
) | nindent 4 }}

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
