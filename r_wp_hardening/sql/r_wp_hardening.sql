DELETE FROM "acl_links_roles" WHERE acl_link_id = (select id from acl_links where slug='r_wp_hardening');
DELETE FROM "acl_links" WHERE slug = 'r_wp_hardening';

SELECT pg_catalog.setval('acl_links_id_seq', (SELECT MAX(id) FROM acl_links), true);

INSERT INTO "acl_links" ("created", "modified", "name", "url", "method", "slug", "group_id", "is_user_action", "is_guest_action", "is_admin_action", "is_hide") values ('now()', 'now()', 'Allow WordPress Hardening', '/r_wp_hardening', '', 'r_wp_hardening', '3', '1', '0', '1', '0');

SELECT pg_catalog.setval('acl_links_roles_roles_id_seq', (SELECT MAX(id) FROM acl_links_roles), true);

INSERT INTO "acl_links_roles" ("created", "modified", "acl_link_id", "role_id") VALUES 
(now(), now(), (select id from acl_links where slug='r_wp_hardening'), '1'),
(now(), now(), (select id from acl_links where slug='r_wp_hardening'), '2');