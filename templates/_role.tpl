{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Role - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "role.base" }}
{{- $o := .options -}}
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
{{- include "metadata.all" . }}
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
