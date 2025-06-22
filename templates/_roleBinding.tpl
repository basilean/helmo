{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  RoleBinding - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.
*/}}
{{- define "roleBinding.base" }}
{{- $o := .options -}}
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
{{- include "metadata.all" . }}
subjects:
  {{- range $subject := $o.subjects }}
  - kind: {{ $subject.kind }}
    name: {{ $subject.name }}
    namespace: {{ $.context.Release.Namespace }}
  {{- end }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ $o.role }}
{{- end }}
