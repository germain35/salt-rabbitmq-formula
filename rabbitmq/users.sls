{%- from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - rabbitmq.install
  - rabbitmq.service

{%- if rabbitmq.admin is defined %}
rabbitmq_user_admin:
  rabbitmq_user.present:
    - name: {{ rabbitmq.admin.name }}
    - password: {{ rabbitmq.admin.password }}
    - force: True
    - tags: administrator
      {%- for vhost, perms in params.get('perms', {}).iteritems() %}
    - perms:
      - '{{ vhost }}':
        {%- for perm in perms %}
        - {{ perm }}
        {%- endfor %}
    {%- endfor %}
    - require:
      - service: rabbitmq_service

{%- endif %}

{%- if rabbitmq.remove_guest_user %}
{#- Delete default guest user if we are not using it #}
rabbitmq_user_guest_absent:
  rabbitmq_user.absent:
    - name: guest
    - require:
      - service: rabbitmq_service
{%- endif %}

{%- for user, params in rabbitmq.get('users', {}).iteritems() %}
rabbitmq_user_{{ user }}:
  rabbitmq_user.present:
    - name: {{ user }}
    - password: {{ params.password }}
    - force: True
    {%- for vhost, perms in params.get('perms', {}).iteritems() %}
    - perms:
      - '{{ vhost }}':
        {%- for perm in perms %}
        - {{ perm }}
        {%- endfor %}
    {%- endfor %}
{%- endfor %}


