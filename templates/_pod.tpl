{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{/*
  Pod - Base

  context = "." Root context.
  name = Unique name.
  options = Options for the object.

NOTES:
* Need selector label in metadata.
* restartPolicy: Always in Deployments/StatefulSets; OnFailure/Never for Jobs
* affinity: rules for pod scheduling (anti-affinity)
* tolerations: run on tainted nodes
* serviceAccountName: my-sa (RBAC)
* securityContext: security settings

*/}}
{{- define "pod.base" }}
{{- $d := .context.Values.global.options }}
{{- $o := .options }}
metadata:
  labels:
    app.kubernetes.io/template: {{ .name }}
{{- include "labels.all" . | indent 4 }}
  annotations:
{{- include "annotations.all" . | indent 4 }}
spec:
  dnsPolicy: ClusterFirst
  {{- if .options.containers }}
  containers:
    {{- range $name, $options := .options.containers }}
{{ include "container.base" (dict "context" $.context "name" $name "options" $options) | indent 4 }}
    {{- end }}
  {{- end }}
  {{- if .options.volumes }}
  volumes:
    {{- range $volume := .options.volumes }}
{{ include "volume.configMap" (dict "context" $.context "name" $volume.name "options" $volume.configMap) | indent 4 }}
      {{/* TODO: volume.base */}}
    {{- end }}
  {{- end }}
{{- end }}