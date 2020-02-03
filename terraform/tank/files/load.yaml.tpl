overload:
  enabled: true
  package: yandextank.plugins.DataUploader
  token_file: "token.txt"
phantom:
  address: ${address}:${port}
  load_profile:
    load_type: rps
    schedule: const(10, 120m)
  ammo_type: uri
  ammofile: ammo_list.txt
  autocases: 1
  multi:
    - address: ${address}:${port}
      load_profile:
        load_type: rps
        schedule: const(1, 120m)
      ammo_type: uripost
      ammofile: ammo_add.txt
      autocases: 1
console:
  enabled: true
telegraf:
  enabled: true
  config: monitoring.xml
