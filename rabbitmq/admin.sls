{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.service

{%- if rabbitmq.admin_enabled %}
rabbitmq_admin_dir:
  file.directory:
    - name: /usr/local/bin
    - user: root
    - mode: 755
    - makedirs: True

rabbitmq_admin_bin:
  cmd.run:
    - name: curl http://localhost:{{ rabbitmq.config.management.port }}/cli/rabbitmqadmin > {{ rabbitmq.admin_bin }}
    - unless: test -x {{ rabbitmq.admin_bin }}
    - require:
      - service: rabbitmq_service
      - file: rabbitmq_admin_dir
  file.managed:
    - name: {{ rabbitmq.admin_bin }}
    - user: root
    - mode: 755
{%- endif %}