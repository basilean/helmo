{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
  Role - Base

  context = . (context)
  name = Name of the object.
  options = Options for the object.
*/}}

{{- define "role.base" }}
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ .name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
rules:
  {{- include "role.rules" .options.rules | indent 2 }}
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
