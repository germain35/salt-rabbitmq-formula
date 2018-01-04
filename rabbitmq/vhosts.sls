{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.install
  - rabbitmq.service

{%- for vhost, params in rabbitmq.get('vhosts', {}).iteritems() %}
  {%- if params.enabled %}
    {%- if vhost != '/' %}

rabbitmq_vhost_{{ vhost }}:
  rabbitmq_vhost.present:
    - name: {{ vhost }}
    - require:
      - service: rabbitmq_service
    {%- endif %}

{%- if params.user is defined %}
rabbitmq_vhost_{{ vhost }}_user_{{ params.user }}:
  rabbitmq_user.present:
    - name: {{ params.user }}
    {%- if params.password is defined %}
    - password: {{ params.password }}
    {%- endif %}
    - force: True
    - perms:
      - '{{ vhost }}':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - rabbitmq_vhost: rabbitmq_vhost_{{ vhost }}
{%- endif %}

    {%- for policy in params.get('policies', []) %}
rabbitmq_policy_{{ vhost }}_{{ policy.name }}:
  rabbitmq_policy.present:
    - name: {{ policy.name }}
    - pattern: {{ policy.pattern }}
    - definition: {{ policy.definition|json }}
    - priority: {{ policy.get('priority', 0)|int }}
    - vhost: {{ vhost }}
    - require:
      - service: rabbitmq_service

    {%- endfor %}

  {%- else %}

rabbitmq_vhost_{{ vhost }}_absent:
  rabbitmq_vhost.absent:
    - name: {{ vhost }}
    - require:
      - service: rabbitmq_service

  {%- endif %}
{%- endfor %}
