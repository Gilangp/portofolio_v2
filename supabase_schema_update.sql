-- ====================================================================
-- SQL SCRIPT UNTUK MEMPERBAIKI DAN MENAMBAHKAN SELURUH KOLOM PENGATURAN
-- (Jalankan script ini di menu "SQL Editor" pada dashboard Supabase Anda)
-- ====================================================================

-- 1. Tambahkan seluruh kolom untuk halaman Settings / Brand / Media Sosial
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS site_title text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS site_logo_text text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS site_logo_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS site_favicon_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS social_github text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS social_linkedin text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS social_instagram text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS social_tiktok text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS social_links jsonb DEFAULT '[]'::jsonb;

-- 2. Tambahkan seluruh kolom untuk halaman Hero (Beranda)
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS profile_photo_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS cv_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_en jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_id jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_id text;

-- 3. Tambahkan seluruh kolom untuk halaman Tentang Saya (About)
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_photo_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_title_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_title_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_bio_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_bio_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_specialty_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS about_specialty_id text;

-- 4. Tambahkan seluruh kolom untuk halaman Kontak (Contact)
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_email text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_location text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_response_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS contact_response_id text;

-- 5. Tambahkan seluruh kolom untuk halaman Footer
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS footer_tagline_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS footer_tagline_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS footer_copyright_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS footer_copyright_id text;

-- 6. Pastikan baris dengan id = 1 selalu ada
INSERT INTO site_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- 7. Muat ulang (reload) cache skema PostgREST Supabase agar perubahan kolom langsung dikenali
NOTIFY pgrst, 'reload schema';
