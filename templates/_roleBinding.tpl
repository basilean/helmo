{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  RoleBinding - Base

  context = . (context)
  options = Options for the object.
*/}}

{{- define "roleBinding.base" }}
{{- $o := .options -}}
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ $o.name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
  annotations:
    {{- include "annotations.all" . | indent 4 }}
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
