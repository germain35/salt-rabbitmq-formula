{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

{%- set osfamily   = salt['grains.get']('os_family') %}
{%- set os         = salt['grains.get']('os') %}
{%- set osrelease  = salt['grains.get']('osrelease') %}
{%- set oscodename = salt['grains.get']('oscodename') %}

include:
  - rabbitmq.install
  - rabbitmq.service

{%- if osfamily == 'Debian' %}

rabbitmq_default_config:
  file.managed:
    - name: {{ rabbitmq.default_file }}
    - source: salt://rabbitmq/templates/default
    - template: jinja
    - user: {{ rabbitmq.user }}
    - group: {{ rabbitmq.group }}
    - mode: 440
    - require:
      - pkg: rabbitmq_packages
    - watch_in:
      - service: rabbitmq_service

{%- endif %}

rabbitmq_config:
  file.managed:
    - name: {{ rabbitmq.config_file }}
    - source: salt://rabbitmq/templates/rabbitmq.config
    - template: jinja
    - user: {{ rabbitmq.user }}
    - group: {{ rabbitmq.group }}
    - makedirs: True
    - mode: 440
    - require:
      - pkg: rabbitmq_packages
    - watch_in:
      - service: rabbitmq_service


{%- if salt['grains.get']('init') == 'systemd' %}

rabbitmq_limits_systemd:
  file.managed:
    - name: {{ rabbitmq.limits_file }}
    - source: salt://rabbitmq/templates/limits.conf
    - template: jinja
    - user: root
    - group: root
    - makedirs: True
    - mode: 0644
    - require:
      - pkg: rabbitmq_packages

{%- endif %}