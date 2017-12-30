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
    - require_in:
      - rabbitmq_user: rabbitmq_user_{{ params.user }}
    {%- endif %}

rabbitmq_user_{{ params.user }}:
  rabbitmq_user.present:
    - name: {{ params.user }}
    - password: {{ params.password }}
    - force: True
    - perms:
      - '{{ vhost }}':
        - '.*'
        - '.*'
        - '.*'
        
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

rabbitmq_user_{{ params.user }}_absent:
  rabbitmq_user.absent:
    - name: {{ params.user }}
    - require:
      - service: rabbitmq_service

  {%- endif %}
{%- endfor %}