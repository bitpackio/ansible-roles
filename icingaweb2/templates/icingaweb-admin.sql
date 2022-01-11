USE {{ icingaweb2_mysql_db.name }}
INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('{{ icingaweb2_web_user.name }}', 1, '{{ icingaweb2_web_user.password | password_hash("md5") }}');
