{{/*
  Helmo
  GNU/GPL v3

  https://github.com/basilean/helmo
*/}}

{{- define "service.auto" }}
{{- $d := .context.Values.global.default.service }}
{{- $o := .options }}
kind: Service
apiVersion: v1
{{- include "metadata.all" . }}
spec:
  type: {{ $o.type }}
{{- include "v.e" (dict "k" "clusterIP" "o" $o) | indent 2 }}
{{- include "v.e" (dict "k" "externalName" "o" $o) | indent 2 }}
  ports:
{{- range $port := .options.ports }}
{{- include "service.port" $port | indent 4}}
{{- end }}
  selector:
{{- include "keys.quote" $o.selector | indent 4}}
{{- end }}

{{- define "service.port" }}
- name: {{ .name }}
{{- include "v.s" (dict "k" "protocol" "o" . "d" (dict) "f" "TCP") | indent 2 }}
{{- include "v.s" (dict "k" "port" "o" . "d" (dict) "f" "8080") | indent 2 }}
{{- include "v.s" (dict "k" "targetPort" "o" . "d" (dict) "f" "8080") | indent 2 }}
{{- include "v.e" (dict "k" "nodePort" "o" .) | indent 2 }}
{{- end }}
