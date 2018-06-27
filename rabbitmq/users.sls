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
    {%- if params.perms is defined and params.perms is mapping %}
    - perms:
      {%- for vhost, perms in params.perms.items() %}
      - '{{ vhost }}':
        {%- for perm in perms %}
        - {{ perm }}
        {%- endfor %}
      {%- endfor %}
    {%- endif %}
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

{%- for user, params in rabbitmq.get('users', {}).items() %}
rabbitmq_user_{{ user }}:
  rabbitmq_user.present:
    - name: {{ user }}
    {%- if params.password is defined %}
    - password: {{ params.password }}
    {%- endif %}
    - force: True
    {%- if params.perms is defined and params.perms is mapping %}
    - perms:
      {%- for vhost, perms in params.perms.items() %}
      - '{{ vhost }}':
        {%- for perm in perms %}
        - {{ perm }}
        {%- endfor %}
      {%- endfor %}
    {%- endif %}
{%- endfor %}


