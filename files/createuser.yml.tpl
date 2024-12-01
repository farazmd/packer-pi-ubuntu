user_groups:
  - group_name: ${groupName}
    state: present
    system: false

users:
  - username: ${userName}
    state: present
    additional_groups:
    %{ for group in additionalGroups ~}
      - ${group}
    %{~ endfor ~}
    create_home: true
    is_system: false 
    add_sudo: true
    authorized_key: "${authorizedKey}"
