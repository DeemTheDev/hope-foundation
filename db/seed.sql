-- Fictional development fixtures; validated against the application schema.
-- Use the approved development branch only. Rolls back by default.
-- Fictional donor IDs are not authenticated Clerk users or actual payments.
-- Rolls back by default; review results before any approved persistent run.
BEGIN;

INSERT INTO organisation (name, email, description, address, website, profile_image_url, image_url)
VALUES ('Community Meals Demo', 'org1@hope-demo.invalid', 'Fictional demo organisation 1; no real donations.', '1 Demo Street', 'https://example.invalid/org1', 'https://example.invalid/placeholder.png', 'https://example.invalid/placeholder.png')
ON CONFLICT (email) DO NOTHING;

INSERT INTO organisation (name, email, description, address, website, profile_image_url, image_url)
VALUES ('Learning Support Demo', 'org2@hope-demo.invalid', 'Fictional demo organisation 2; no real donations.', '2 Demo Street', 'https://example.invalid/org2', 'https://example.invalid/placeholder.png', 'https://example.invalid/placeholder.png')
ON CONFLICT (email) DO NOTHING;

INSERT INTO organisation (name, email, description, address, website, profile_image_url, image_url)
VALUES ('Animal Care Demo', 'org3@hope-demo.invalid', 'Fictional demo organisation 3; no real donations.', '3 Demo Street', 'https://example.invalid/org3', 'https://example.invalid/placeholder.png', 'https://example.invalid/placeholder.png')
ON CONFLICT (email) DO NOTHING;

INSERT INTO users (name, email, clerk_id)
VALUES ('Demo Donor 1', 'donor1@hope-demo.invalid', 'fixture_donor_1')
ON CONFLICT (clerk_id) DO NOTHING;

INSERT INTO users (name, email, clerk_id)
VALUES ('Demo Donor 2', 'donor2@hope-demo.invalid', 'fixture_donor_2')
ON CONFLICT (clerk_id) DO NOTHING;

INSERT INTO donations (amount, donation_date, organisation_id, donor_id)
SELECT '10.00'::numeric, '2026-10-13'::date, o.id, 'fixture_donor_2'
FROM organisation o WHERE o.email = 'org1@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM donations d WHERE d.organisation_id = o.id AND d.donor_id = 'fixture_donor_2' AND d.amount = '10.00'::numeric AND d.donation_date = '2026-10-13'::date);

INSERT INTO donations (amount, donation_date, organisation_id, donor_id)
SELECT '20.00'::numeric, '2026-10-13'::date, o.id, 'fixture_donor_1'
FROM organisation o WHERE o.email = 'org1@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM donations d WHERE d.organisation_id = o.id AND d.donor_id = 'fixture_donor_1' AND d.amount = '20.00'::numeric AND d.donation_date = '2026-10-13'::date);

INSERT INTO donations (amount, donation_date, organisation_id, donor_id)
SELECT '30.00'::numeric, '2026-10-13'::date, o.id, 'fixture_donor_2'
FROM organisation o WHERE o.email = 'org2@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM donations d WHERE d.organisation_id = o.id AND d.donor_id = 'fixture_donor_2' AND d.amount = '30.00'::numeric AND d.donation_date = '2026-10-13'::date);

INSERT INTO donations (amount, donation_date, organisation_id, donor_id)
SELECT '40.00'::numeric, '2026-10-13'::date, o.id, 'fixture_donor_1'
FROM organisation o WHERE o.email = 'org2@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM donations d WHERE d.organisation_id = o.id AND d.donor_id = 'fixture_donor_1' AND d.amount = '40.00'::numeric AND d.donation_date = '2026-10-13'::date);

INSERT INTO donations (amount, donation_date, organisation_id, donor_id)
SELECT '50.00'::numeric, '2026-10-13'::date, o.id, 'fixture_donor_2'
FROM organisation o WHERE o.email = 'org3@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM donations d WHERE d.organisation_id = o.id AND d.donor_id = 'fixture_donor_2' AND d.amount = '50.00'::numeric AND d.donation_date = '2026-10-13'::date);

INSERT INTO blog_posts (org_id, content, type)
SELECT o.id, 'Fictional demonstration post for Community Meals Demo.', 'Post'
FROM organisation o WHERE o.email = 'org1@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM blog_posts b WHERE b.org_id = o.id AND b.content = 'Fictional demonstration post for Community Meals Demo.' AND b.type = 'Post');

INSERT INTO blog_posts (org_id, content, type)
SELECT o.id, 'Fictional demonstration post for Learning Support Demo.', 'Post'
FROM organisation o WHERE o.email = 'org2@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM blog_posts b WHERE b.org_id = o.id AND b.content = 'Fictional demonstration post for Learning Support Demo.' AND b.type = 'Post');

INSERT INTO blog_posts (org_id, content, type)
SELECT o.id, 'Fictional demonstration post for Animal Care Demo.', 'Post'
FROM organisation o WHERE o.email = 'org3@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM blog_posts b WHERE b.org_id = o.id AND b.content = 'Fictional demonstration post for Animal Care Demo.' AND b.type = 'Post');

-- Optional organisation login fixtures require a private session setting.
INSERT INTO authorised_organisations (organisation_id, email, password)
SELECT o.id, o.email, current_setting('hope.seed_password', true)
FROM organisation o
WHERE o.email IN ('org1@hope-demo.invalid','org2@hope-demo.invalid','org3@hope-demo.invalid')
  AND COALESCE(current_setting('hope.seed_password', true), '') <> ''
ON CONFLICT (organisation_id) DO NOTHING;

INSERT INTO organisation_images (organisation_id, image_url)
SELECT o.id, 'https://picsum.photos/seed/hope-demo-gallery1/800/600'
FROM organisation o WHERE o.email = 'org1@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM organisation_images i WHERE i.organisation_id = o.id AND i.image_url = 'https://picsum.photos/seed/hope-demo-gallery1/800/600');
INSERT INTO organisation_images (organisation_id, image_url)
SELECT o.id, 'https://picsum.photos/seed/hope-demo-gallery2/800/600'
FROM organisation o WHERE o.email = 'org2@hope-demo.invalid'
AND NOT EXISTS (SELECT 1 FROM organisation_images i WHERE i.organisation_id = o.id AND i.image_url = 'https://picsum.photos/seed/hope-demo-gallery2/800/600');

-- Expected fixture counts: organisations 3; users 2; donations 5; blog posts 3.
SELECT 'organisations' AS fixture, count(*) AS rows FROM organisation WHERE email IN ('org1@hope-demo.invalid','org2@hope-demo.invalid','org3@hope-demo.invalid')
UNION ALL SELECT 'users', count(*) FROM users WHERE clerk_id IN ('fixture_donor_1','fixture_donor_2')
UNION ALL SELECT 'donations', count(*) FROM donations WHERE donor_id IN ('fixture_donor_1','fixture_donor_2')
UNION ALL SELECT 'blog_posts', count(*) FROM blog_posts WHERE content LIKE 'Fictional demonstration post for %';
ROLLBACK;
