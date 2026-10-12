
-- =========================================================
-- VOUCHER KAS KELUAR
-- Dokumentasi RLS policies yang ditemukan di Supabase
-- File ini merupakan catatan konfigurasi yang sudah ada.
-- Jangan jalankan ulang untuk mengubah database.
-- =========================================================

-- Tabel audit_logs:
-- RLS aktif.
-- Pengguna authenticated boleh membaca audit logs.

CREATE POLICY authenticated_can_read_audit_logs
ON public.audit_logs
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (true);

-- Catatan hasil pemeriksaan:
-- accounts: RLS tidak aktif
-- cash_vouchers: RLS tidak aktif
-- cash_voucher_lines: RLS tidak aktif
-- audit_logs: RLS aktif
--
-- Perhatian:
-- Pernyataan CREATE POLICY di atas hanya dokumentasi.
-- Policy dengan nama yang sama sudah ada di database.
-- Jangan jalankan file ini pada database yang sudah ada.