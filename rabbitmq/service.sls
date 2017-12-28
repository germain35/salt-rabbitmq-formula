{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.install

rabbitmq_service:
  service.running:
    - name: {{ rabbitmq.service }}
    - enable: {{ rabbitmq.service_enabled }}
    - reload: {{ rabbitmq.service_reload }}
    - require:
        - pkg: rabbitmq_packages
