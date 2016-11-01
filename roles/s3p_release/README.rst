s3p_release
############

This role depends on s3p, so that should always be listed first.

Additionally this role should never be used directly but instead encapsulated in another role.

For example: `~/taco-playbooks/app.yml`

.. code-block:: yaml

 - hosts: app
   become: yes
   become_user: root
   vars_prompt:
     - name: vpc_name
       private: no
   vars_files:
     - ~/ansible-secrets/vars/{{ vpc_name }}.yml
   roles:
     - nodejs
     - s3p
     - s3p_release
     - app

In addition the following `defaults` are expected to be set / hardcoded:

`~/taco-playbooks/roles/app/defaults/main.yml`

.. code-block:: yaml
 ---
 role_name: app
 service_name: taco-api
 rpm_name: taco-api.rpm

Here is another role with different `defaults`:

`~/taco-playbooks/roles/agenda/defaults/main.yml`

.. code-block:: yaml
 ---
 role_name: agenda
 service_name: taco-agenda
 rpm_name: taco-agenda.rpm

Obviously these values will need to be customized for your particular project.
