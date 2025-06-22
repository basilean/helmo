{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Role - Base

  context = . (context)
  options = Options for the object.
*/}}

{{- define "role.base" }}
{{- $o := .options -}}
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ $o.name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
rules:
  {{- include "role.rules" $o.rules | indent 2 }}
{{- end }}

{{- define "role.rules" }}
{{- range $rule := . }}
  {{- range $key, $vals := $rule }}
- {{ $key }}:
    {{- range $val := $vals }}
  - {{ $val | quote }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
