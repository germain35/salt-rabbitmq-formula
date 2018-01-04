{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.service

{%- if rabbitmq.admin_enabled %}
rabbitmq_admin_bin:
  file.directory:
    - name: /usr/local/bin
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
  cmd.run:
    - name: curl http://localhost:{{ rabbitmq.config.management.port }}/cli/rabbitmqadmin > {{ rabbitmq.admin_bin }}
    - unless: test -x {{ rabbitmq.admin_bin }}
    - require:
      - service: rabbitmq_service
  file.managed:
    - name: {{ rabbitmq.admin_bin }}
    - user: root
    - group: root
    - mode: 755
{%- endif %}