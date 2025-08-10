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
{{- $d := .context.Values.global.default.container -}}
{{- $o := .options -}}
- name: {{ .name }}
  image: {{ (printf "%s/%s/%s:%s"
    (include "v.p" (dict "k" "registry" "o" $o "d" $d.image "f" "docker.io"))
    (include "v.p" (dict "k" "org" "o" $o "d" $d.image "f" .context.Release.Name))
    (include "v.p" (dict "k" "name" "o" $o "d" $d.image "f" "busybox"))
    (include "v.p" (dict "k" "tag" "o" $o "d" $d.image "f" "latest"))
  ) }}
{{- include "v.s" (dict "k" "workingDir" "o" $o "d" $d) | indent 2 }}
{{- include "l.s" (dict "k" "command" "o" $o "d" $d) | indent 2 }}
{{- include "l.s" (dict "k" "args" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "imagePullPolicy" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "terminationMessagePath" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "terminationMessagePolicy" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "stdin" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "stdinOnce" "o" $o "d" $d) | indent 2 }}
{{- include "v.s" (dict "k" "tty" "o" $o "d" $d) | indent 2 }}

{{- /* securityContext */}}
{{- if (or $o.securityContext $d.securityContext) }}
  securityContext:
  {{- $os := (default dict $o.securityContext) }}
  {{- $ds := (default dict $d.securityContext) }}
{{- include "v.s" (dict "k" "allowPrivilegeEscalation" "o" $os "d" $ds "f" false) | indent 4 }}
{{- include "v.s" (dict "k" "privileged" "o" $os "d" $ds "f" false) | indent 4 }}
{{- include "v.s" (dict "k" "runAsUser" "o" $os "d" $ds) | indent 4 }}
{{- include "v.s" (dict "k" "readOnlyRootFilesystem" "o" $os "d" $ds "f" true) | indent 4 }}
{{- if (or $os.capabilities $ds.capabilities) }}
    capabilities:
{{- include "l.s" (dict "k" "drop" "o" $os.capabilities "d" $ds.capabilities) | indent 6 }}
{{- end }}
{{- end }}

{{- /* resources */}}
{{- if (or $o.resources $d.resources) }}
  {{- $or := default dict $o.resources }}
  {{- $dr := default dict $d.resources }}
  resources:
{{- if (or $or.requests $dr.requests) }}
    requests:
{{- include "v.s" (dict "k" "cpu" "o" $or.requests "d" $dr.requests) | indent 6 }}
{{- include "v.s" (dict "k" "memory" "o" $or.requests "d" $dr.requests) | indent 6 }}
{{- end }}
{{- if (or $or.limits $dr.limits) }}
    limits:
{{- include "v.s" (dict "k" "cpu" "o" $or.limits "d" $dr.limits) | indent 6 }}
{{- include "v.s" (dict "k" "memory" "o" $or.limits "d" $dr.limits) | indent 6 }}
{{- end }}
{{- end }}

{{- /* env */}}
{{- if (or $o.env $d.env) }}
{{- $oe := default dict $o.env }}
{{- $de := default dict $d.env }}
{{- $m := mergeOverwrite $de $oe }}
  env:
{{- range $k, $v := $m }}
{{- if hasKey $v "value" }}
    - name: {{ $k }}
      value: {{ $v.value }}
{{- else if hasKey $v "valueFrom" }}
    - name: {{ $k }}
      valueFrom:
{{- $vf := first (keys $v.valueFrom) }}
        {{ $vf }}:
{{- $vo := get $v.valueFrom $vf }}
{{- include "v.e" (dict "k" "name" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "key" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "optional" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "fieldPath" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "containerName" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "resource" "o" $vo) | indent 10 }}
{{- include "v.e" (dict "k" "divisor" "o" $vo) | indent 10 }}
{{- else }}
{{- end }}
{{- end }}
{{- end }}

{{- /* envFrom */}}
{{- if (or $o.envFrom $d.envFrom) }}
{{- $oe := default list $o.envFrom }}
{{- $de := default list $d.envFrom }}
  envFrom:
{{- range $k := concat $de $oe }}
{{- $vf := first (keys $k) }}
    - {{ $vf }}:
{{- $vo := get $k $vf }}
{{- include "v.e" (dict "k" "name" "o" $vo) | indent 8 }}
{{- include "v.e" (dict "k" "optional" "o" $vo) | indent 8 }}
{{- end }}
{{- end }}

{{- /* ports */}}
{{- if (or $o.ports $d.ports)}}
{{- $op := default list $o.ports }}
{{- $dp := default list $d.ports }}
  ports:
{{- range $p := concat $dp $op }}
    - containerPort: {{ $p.containerPort }}
{{- include "v.e" (dict "k" "name" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "protocol" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "hostPort" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "hostIP" "o" $p) | indent 6 }}
{{- end }}
{{- end }}

{{- /* volumeMounts */}}
{{- if (or $o.volumeMounts $d.volumeMounts)}}
{{- $op := default list $o.volumeMounts }}
{{- $dp := default list $d.volumeMounts }}
  volumeMounts:
{{- range $p := concat $dp $op }}
    - name: {{ $p.name }}
{{- include "v.e" (dict "k" "mountPath" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "readOnly" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "subPath" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "subPathExpr" "o" $p) | indent 6 }}
{{- include "v.e" (dict "k" "mountPropagation" "o" $p) | indent 6 }}
{{- end }}
{{- end }}

{{- /* volumeDevices */}}
{{- if (or $o.volumeDevices $d.volumeDevices)}}
{{- $op := default list $o.volumeDevices }}
{{- $dp := default list $d.volumeDevices }}
  volumeDevices:
{{- range $p := concat $dp $op }}
    - name: {{ $p.name }}
      devicePath: {{ $p.devicePath }}
{{- end }}
{{- end }}

{{- /* lifecycle */}}
{{- if (or $o.lifecycle $d.lifecycle)}}
{{- $ol := default dict $o.lifecycle }}
{{- $dl := default dict $d.lifecycle }}
  lifecycle:
{{- if (or $ol.postStart $dl.postStart)}}
    postStart:
{{- $op := default dict $ol.postStart }}
{{- $dp := default dict $dl.postStart }}
      exec:
{{- include "l.s" (dict "k" "command" "o" $op.exec "d" $dp.exec) | indent 8 }}
{{- end }}
{{- if (or $ol.preStop $dl.preStop)}}
    preStop:
{{- $op := default dict $ol.preStop }}
{{- $dp := default dict $dl.preStop }}
      exec:
{{- include "l.s" (dict "k" "command" "o" $op.exec "d" $dp.exec) | indent 8 }}
{{- end }}
{{- end }}

{{- /* startupProbe */}}
{{- /* livenessProbe */}}
{{- /* readinessProbe */}}
{{- range $k := (list "startupProbe" "livenessProbe" "readinessProbe")}}
{{- if (hasKey $o $k)}}
{{- $op := get $o $k }}
{{- $dp := default dict (get $d $k) }}
  {{ $k }}:
{{- include "v.s" (dict "k" "initialDelaySeconds" "o" $op "d" $dp) | indent 4 }}
{{- include "v.s" (dict "k" "periodSeconds" "o" $op "d" $dp) | indent 4 }}
{{- include "v.s" (dict "k" "timeoutSeconds" "o" $op "d" $dp) | indent 4 }}
{{- include "v.s" (dict "k" "successThreshold" "o" $op "d" $dp) | indent 4 }}
{{- include "v.s" (dict "k" "failureThreshold" "o" $op "d" $dp) | indent 4 }}
{{- if (hasKey $op "exec")}}
    exec:
{{- include "l.s" (dict "k" "command" "o" $op.exec "d" $dp.exec) | indent 6 }}
{{- else if (hasKey $op "grpc")}}
    grpc:
{{- include "v.s" (dict "k" "port" "o" $op.grpc "d" $dp.grpc) | indent 6 }}
{{- include "v.s" (dict "k" "service" "o" $op.grpc "d" $dp.grpc) | indent 6 }}
{{- else if (hasKey $op "tcpSocket")}}
    tcpSocket:
{{- include "v.s" (dict "k" "port" "o" $op.tcpSocket "d" $dp.tcpSocket) | indent 6 }}
{{- else if (hasKey $op "httpGet")}}
    httpGet:
{{- $dh := default dict $dp.httpGet }}
{{- include "v.s" (dict "k" "port" "o" $op.httpGet "d" $dp.httpGet) | indent 6 }}
{{- include "v.s" (dict "k" "path" "o" $op.httpGet "d" $dp.httpGet) | indent 6 }}
{{- include "v.s" (dict "k" "scheme" "o" $op.httpGet "d" $dp.httpGet) | indent 6 }}
{{- if or (hasKey $op.httpGet "httpHeaders") (hasKey $dh "httpHeaders") }}
      httpHeaders:
{{- $l := concat (default list $op.httpGet.httpHeaders) (default list $dh.httpHeaders)}}
{{- range $i := $l }}
        - name: {{ $i.name }}
          value: {{ $i.value }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- end }}