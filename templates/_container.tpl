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
- name: {{ .name }}
  securityContext:
  {{- $os := (default dict $o.securityContext) }}
{{- include "v.s" (dict "k" "allowPrivilegeEscalation" "o" $os "d" $d "f" false) | indent 4 }}
{{- include "v.s" (dict "k" "privileged" "o" $os "d" $d "f" false) | indent 4 }}
{{- include "v.s" (dict "k" "runAsUser" "o" $os "d" $d) | indent 4 }}
{{- include "v.s" (dict "k" "readOnlyRootFilesystem" "o" $os "d" $d "f" true) | indent 4 }}
    capabilities:
{{- include "l.s" (dict "k" "drop" "o" $o "d" $d "f" (list "ALL")) | indent 6 }}
  {{- $oi := (default dict $o.image) }}
  {{- $di := (default dict $d.image) }}
  image: {{ (printf "%s/%s:%s"
    (include "v.p" (dict "k" "registry" "o" $oi "d" $di "f" "docker.io"))
    (include "v.p" (dict "k" "path" "o" $oi "d" $di "f" "library/busybox"))
    (include "v.p" (dict "k" "version" "o" $oi "d" $di "f" "latest"))
  ) }}
{{- include "v.s" (dict "k" "workingDir" "o" $o "d" $d) | indent 2 }}
{{- include "l.s" (dict "k" "command" "o" $o "d" $d) | indent 2 }}
{{- include "l.s" (dict "k" "args" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "imagePullPolicy" "o" $o "d" $d) | indent 2 }}
  {{- $or := default dict $o.resources }}
  {{- $dr := default dict $d.resources }}
  resources:
    {{- $orr := default dict $or.request }}
    {{- $drr := default dict $dr.request }}
    requests:
      cpu: {{ include "v.p" (dict "k" "cpu" "o" $orr "d" $drr "f" "100m") }}
      memory: {{ include "v.p" (dict "k" "memory" "o" $orr "d" $drr "f" "200Mi") }}
    {{- $orl := default dict $or.limits }}
    {{- $drl := default dict $dr.limits }}
    limits:
      cpu: {{ include "v.p" (dict "k" "cpu" "o" $orl "d" $drl "f" "200m") }}
      memory: {{ include "v.p" (dict "k" "memory" "o" $orl "d" $drl "f" "400Mi") }}

{{- if $o.ports }}
  ports:
  {{- toYaml $o.ports | nindent 4 }}
{{- end }}
{{- if $o.volumeMounts }}
  volumeMounts:
    {{- range $name, $options := $o.volumeMounts }}
{{ include "volume.mount" (dict "context" $.context "name" $name "options" $options) | indent 4 }}
    {{- end }}
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
