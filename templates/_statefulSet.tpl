{{/*
  Helmo (https://github.com/basilean/helmo)
  Andres Basile
  GNU/GPL v3
*/}}

{{/*
        StatefulSet - Base
*/}}
{{- define "ss.base" }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Chart.Name }}
  labels:
    {{- include "labels.all" . | indent 4 }}
spec:
  serviceName: {{ .Chart.Name }}
  revisionHistoryLimit: 1
  persistentVolumeClaimRetentionPolicy:
    whenDeleted: Retain
    whenScaled: Retain
  volumeClaimTemplates:
    - kind: PersistentVolumeClaim
      apiVersion: v1
      metadata:
        name: data
        labels:
          {{- include "labels.all" . | indent 10 }}
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 20Gi
        storageClassName: thin-apps
        volumeMode: Filesystem
  template:
    metadata:
      labels:
        {{- include "labels.all" . | indent 8 }}
      annotations:
        {{- include "annotations.all" . | indent 8 }}
        kubectl.kubernetes.io/default-container: {{ .Chart.Name }}
    spec:
      volumes:
        - name: config
          configMap:
            name: {{ .Chart.Name }}
            defaultMode: 420
        - name: tls
          secret:
            secretName: {{ .Chart.Name }}-tls
            defaultMode: 420
      containers:
        - resources: {}
          terminationMessagePath: /dev/termination-log
          name: {{ .Chart.Name }}
          env:
            - name: CUSTOM_ARGS
              value: '--server.http.listen-addr=0.0.0.0:12345'
          ports:
            - name: otlp
              containerPort: 4317
              protocol: TCP
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: data
              mountPath: /var/lib/{{ .Chart.Name }}
            - name: config
              mountPath: /etc/{{ .Chart.Name }}
            - name: tls
              mountPath: /tls
          terminationMessagePolicy: FallbackToLogsOnError
          image: 'registry.hub.docker.com/grafana/{{ .Chart.Name }}:v1.4.2'
          args:
            - run
            - /etc/{{ .Chart.Name }}/config.{{ .Chart.Name }}
            - '--storage.path=/var/lib/{{ .Chart.Name }}/data'
            - '--server.http.listen-addr=0.0.0.0:12345'
            - '--stability.level=experimental'
      restartPolicy: Always
      terminationGracePeriodSeconds: 180
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
  podManagementPolicy: Parallel
  replicas: 1
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Chart.Name }}
{{- end }}
