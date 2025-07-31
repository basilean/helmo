# Helmo
A collection of template helpers to work with Helm.

![Helmo](helmo.png)

The goal is to have a centralized place for helpers and templates that have been created following best practices, or at least some logic, to be used once and again.

Nowadays, all of these have been created by myself while learning Helm and ArgoCD at home, I published them to don't repeat myself [(DRY)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) at work and be able to use them everywhere. Everyone is invited to use them and collaborate.

## Architecture
*It just follows Helm flow.*

⬛✍️Values  
⬛⬛⬛↘️  
⬛⬛🔗Template 🟰 Rendered Objects 👾  
⬛⬛⬛🔃  
⬛⚙️Helpers  

### Helpers
They are immutable. The logic behind tries to contemplate all common options for an object, having an optional default value for them to avoid target cluster defaults. Additionally, metadata can be injected on all objects. By the end, this is the code to be used once and again.

> /templates/*.tpl

### Templates
They work as binding. It could be always the same "auto.yaml" that is a helper by itself, following a pattern of reading a structured "values.yaml" and filling a related helper out to produce target object. Here is where you optionally can define how the helpers are being used and which set of values are being passed to them.

> /charts/*/templates/auto.yaml

### Values
They are mutable part where an application is defined. Dict were used so it is easier to reference and overwrite. Global section is used to define main defaults. Remember that it is possible to create a new "values-XYZ.yaml" overwriting all past definitions, it is almost a requirement to deploy multiples instances over a variety of clusters and environments.

> /values.yaml  
> /charts/*/values.yaml  
> /values-XYZ.yaml    

**Values Pattern for Auto**
```yaml
job: # Kind (helper name)
  mtls: # Unique Name for this kind of object in target namespace.
    annotation: # Option 1
      argocd.argoproj.io/sync-wave: 1 # Value
    containers: # Option 2
      script: # Unique Name inside containers. 
        image: # Sub Option
          registry: docker.io # Value
          path: library/busybox # Value
          version: latest # Value
```

## Road Map
✅ Completed | 🛠️ Work in Progress | ❌ Planed

### auto
* ✅ Bind templates.

### configMap
* ✅ Files.
* 🛠️ Binary files.
* ❌ Key/Value pairs.
* ❌ Inmutable option.

### container
* ✅ Base.
* ❌ Add mounts.
* ❌ Add ports.

### deployment
* ✅ Base.
* ❌ Add rolling updates.

### externalSecret
* ❌ Pending.

### helpers.
* ❌ Keys raw.
* ✅ Keys quote.
* ✅ Keys base 64.
* ✅ Labels all.
* ✅ Annotations all.

### job
* ✅ Base.
* ❌ Handle restartPolicy.

### networkPolicy
* ❌ Pending.

### pod
* ✅ Base.
* ✅ Containers.
* ❌ Volumes.

### role
* ✅ Base.
* ✅ Rules.

### roleBinding
* ✅ Base.

### route
* ❌ Pending.

### secret
* ❌ Random value.
* ❌ Files.
* ❌ Binary files.
* ❌ Key/Value pairs.
* ❌ Inmutable option.

### secretStore
* ❌ Pending.

### service
* ❌ ClusterIP.
* ❌ NodePort.

### serviceAccount
* ✅ Base.

### statefulSet
* ✅ Base.
* ❌ Ensure no host name nor domain name.
* ❌ Add volumeClaimTemplate.

### volumeClaimTemplate
* ❌ Pending.

### volumes
* ✅ Add configMap.
* ❌ Add auto.
* ❌ Add secret.
* ❌ Add emptyDir.
