{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.install
  - rabbitmq.service

{%- for plugin in rabbitmq.get('plugins', []) %}
rabbitmq_plugin_{{ plugin }}:
  rabbitmq_plugin.enabled:
  - name: {{ plugin }}
  - require:
    - service: rabbitmq_service
{%- endfor %}