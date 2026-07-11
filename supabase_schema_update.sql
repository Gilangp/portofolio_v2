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

-- 6. Tambahkan kolom is_visible untuk manajemen visibilitas Proyek dan Keahlian (Skills)
ALTER TABLE projects ADD COLUMN IF NOT EXISTS is_visible boolean DEFAULT true;
ALTER TABLE skills ADD COLUMN IF NOT EXISTS is_visible boolean DEFAULT true;

-- 7. Hapus seluruh constraint NOT NULL secara eksplisit pada semua kolom di tabel site_settings
ALTER TABLE public.site_settings ALTER COLUMN name DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN hero_greeting_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN hero_greeting_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN hero_roles DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN hero_desc_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN hero_desc_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_title_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_title_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_bio_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_bio_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_specialty_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN about_specialty_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN contact_email DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN contact_location DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN contact_response_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN contact_response_id DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN site_title DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN footer_copyright_en DROP NOT NULL;
ALTER TABLE public.site_settings ALTER COLUMN footer_copyright_id DROP NOT NULL;

-- 8. Blok pengaman tambahan untuk menghapus constraint NOT NULL pada kolom lain jika ada
DO $$
DECLARE
    col_name text;
BEGIN
    FOR col_name IN 
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'site_settings' AND column_name != 'id'
    LOOP
        EXECUTE format('ALTER TABLE public.site_settings ALTER COLUMN %I DROP NOT NULL;', col_name);
    END LOOP;
END $$;

-- 9. Pastikan baris dengan id = 1 selalu ada dengan mengisi nilai default untuk seluruh kolom wajib
INSERT INTO public.site_settings (
  id, name, hero_desc_en, hero_desc_id, about_bio_en, about_bio_id, about_specialty_en, about_specialty_id
) VALUES (
  1, 'Gilang Purnomo', '', '', '', '', '', ''
) ON CONFLICT (id) DO NOTHING;

-- 10. Muat ulang (reload) cache skema PostgREST Supabase agar perubahan kolom langsung dikenali
NOTIFY pgrst, 'reload schema';
