{{/* Generate basic labels for my charts */}}
{{- define "mychart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    app: {{ default "unknown" .name }}
    version: {{ default "unknown" .version | quote }}
    {{- if .labels }}
    {{- range $key, $value := .labels }}
    {{ $key }}: {{ $value | toYaml | trimSuffix "\n" | indent 2 }}
    {{- end }}
    {{- end }} 
{{- end }}  {{/* End of mychart.labels template */}}



{{/* The metadata for all of my charts */}}
{{- define "mychart.metadata" }}
metadata:
  name: {{ .name }}
  namespace: {{ default "default" .namespace }}
  {{- include "mychart.labels" $ }}
{{- end }}  {{/* End of mychart.metadata template */}}


{{/* Generate a service for my charts, based upon the passed object */}}
{{- define "mychart.service" }}
{{- if and .enabled .service }}
apiVersion: v1
kind: Service
{{- template "mychart.metadata" $ }}
spec:
  type: {{ .service_type }}
  selector:
    app: {{ .name }}
  ports:
  {{- range .service }}
  - protocol: {{ .protocol }}
    {{- if .nodePort }}
    nodePort: {{ .nodePort }}
    {{- end }}
    {{- if .port }}
    port: {{ .port }}
    {{- end }}
    {{- if .name }}
    name: {{ .name }}
    {{- end }}
    {{- if .targetPort }}
    targetPort: {{ .targetPort }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }} {{- /* End of the mychart.service template */ -}}


{{- /* Generate a persistent volume's for my charts, based upon the passed object */}}
{{- define "mychart.persistent_volume" }}
{{/* If our pod is enabled and has a persistentVolume defined */}}
{{- if and .enabled .persistentVolume }}
{{- $object := . -}}
{{/* # Loop through the defined volumes */}}
{{- range .persistentVolume.volumes }}   
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ .name }}
  namespace: {{ default "default" $object.namespace }}
{{- template "mychart.metadata" . }}
spec:
  storageClassName: {{ .storageClassName }}
  capacity:
    storage: {{ .storage }}
  accessModes: {{ .accessModes }}
  persistentVolumeReclaimPolicy: {{ .persistentVolumeReclaimPolicy }}
  hostPath:  
    path: {{ .hostPath }}
{{- end }}
{{- end }}
{{- end }} {{- /* End of the mychart.persistent_volume template */ -}}


{{/* Generate a persistent volume's for my charts, based upon the passed object */}}
{{- define "mychart.persistent_volume_claim" }}
{{- if and .enabled .persistentVolume }}
{{- $object := . -}}
{{- range .persistentVolume.volumes }}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .name }}
  namespace: {{ default "default" $object.namespace }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    app: {{ default "unknown" .name }}
    version: {{ default "unknown" .version | quote }}
spec:
  volumeName: {{ .name }}
  accessModes: {{ .accessModes }}
  storageClassName: {{ .storageClassName }}
  resources:
    requests:
      storage: {{ .storage }}
{{- end }}
{{- end }}
{{- end }} {{- /* End of the mychart.persistent_volume_clain template */ -}}


{{/* Generate a statefulset's for my charts, based upon the passed object */}}
{{- define "mychart.statefulset" }}
{{- if .enabled }}
---
apiVersion: apps/v1
kind: StatefulSet
{{- template "mychart.metadata" . }}
spec:
  replicas: {{ .replicas }}
  {{- if .serviceName }}
  serviceName: {{ .serviceName }}
  {{- end }}
  selector:
    matchLabels:
      app: {{ .name }}
  template:
    metadata:
      labels:
        app: {{ .name }}
    spec:
      containers:
      - name: {{ .name }}
        image: {{ .image }}
        imagePullPolicy: {{ .imagePullPolicy }}
        env:
          {{- range .env }}
          - name: {{ .name | quote }}
            value: {{ .value | quote }}
          {{- end }}
        ports:
        {{- range .service }}
        - containerPort: {{ .port }}
        {{- if .name }}
          name: {{ .name }}
        {{- end }}
        {{- end }}
      {{- /* Add volumemounts/volumes if they are required */ -}}
      {{- if .persistentVolume }}
        volumeMounts:
        {{- range .persistentVolume.volumes }}
        - name: {{ .name }}
          mountPath: {{ .mountPath }}
        {{- end }}
      volumes:
      {{- range .persistentVolume.volumes }}
      - name: {{ .name }}
        persistentVolumeClaim:
          claimName: {{ .name }}
      {{- end }}
      {{- end }}
{{- end }}
{{- end }} {{- /* End of the mychart.statefulset template */ -}}