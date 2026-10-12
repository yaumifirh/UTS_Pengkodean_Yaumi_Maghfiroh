
-- =========================================================
-- VOUCHER KAS KELUAR
-- Dokumentasi trigger yang terpasang di Supabase
-- Jangan jalankan ulang pada database yang sudah ada.
-- =========================================================

-- 1. Mencegah perubahan atau penghapusan audit log
CREATE TRIGGER trg_prevent_audit_truncate
BEFORE TRUNCATE ON public.audit_logs
FOR EACH STATEMENT
EXECUTE FUNCTION public.prevent_audit_log_changes();

CREATE TRIGGER trg_prevent_audit_update_delete
BEFORE DELETE OR UPDATE ON public.audit_logs
FOR EACH ROW
EXECUTE FUNCTION public.prevent_audit_log_changes();

-- 2. Mencatat perubahan pada rincian jurnal
CREATE TRIGGER trg_audit_voucher_line_changes
AFTER INSERT OR DELETE OR UPDATE ON public.cash_voucher_lines
FOR EACH ROW
EXECUTE FUNCTION public.audit_cash_voucher_line_event();

-- 3. Melindungi rincian jurnal voucher yang sudah POSTED
CREATE TRIGGER trg_protect_posted_voucher_lines
BEFORE INSERT OR DELETE OR UPDATE ON public.cash_voucher_lines
FOR EACH ROW
EXECUTE FUNCTION public.prevent_posted_voucher_line_changes();

-- 4. Mencatat pembuatan voucher
CREATE TRIGGER trg_audit_voucher_create
AFTER INSERT ON public.cash_vouchers
FOR EACH ROW
EXECUTE FUNCTION public.audit_cash_voucher_event();

-- 5. Mencatat perubahan status atau data voucher
CREATE TRIGGER trg_audit_voucher_post
AFTER UPDATE ON public.cash_vouchers
FOR EACH ROW
EXECUTE FUNCTION public.audit_cash_voucher_event();

-- 6. Melindungi voucher yang sudah POSTED
CREATE TRIGGER trg_protect_posted_voucher
BEFORE DELETE OR UPDATE ON public.cash_vouchers
FOR EACH ROW
EXECUTE FUNCTION public.prevent_posted_voucher_changes();

-- 7. Memvalidasi voucher sebelum diposting
CREATE TRIGGER trg_validate_voucher_before_posting
BEFORE UPDATE OF status ON public.cash_vouchers
FOR EACH ROW
EXECUTE FUNCTION public.validate_voucher_before_posting();