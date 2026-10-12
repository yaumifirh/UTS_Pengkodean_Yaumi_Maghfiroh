Saya sedang menyelesaikan tugas UTS berupa aplikasi web Voucher Entri Transaksi Kas Keluar. Saya sudah memiliki kode frontend dari Gemini Canvas dalam file index.html dan database PostgreSQL di Supabase.
Tolong PERBAIKI KODE YANG SUDAH ADA, bukan membuat aplikasi baru dari nol. Pertahankan desain, layout, warna, komponen, dan fitur yang sudah berfungsi. Fokus pada perbaikan integrasi frontend dengan database Supabase yang sudah tersedia.
A. ATURAN UTAMA
1. Jangan menghapus atau mengganti struktur tabel, kolom, constraint, function, trigger, maupun kebijakan keamanan yang sudah ada di Supabase.
2. Jangan membuat ulang database atau menyuruh saya menjalankan seluruh SQL dari awal.
3. Jangan mengasumsikan adanya kolom yang belum pasti tersedia.
4. Gunakan nama kolom sesuai database yang sebenarnya, bukan nama properti dari data dummy frontend.
5. Jangan mengganti seluruh desain aplikasi. Lakukan perubahan sekecil mungkin agar aplikasi berfungsi dan konsisten dengan database.
6. Pertahankan fitur yang sudah ada selama tidak bertentangan dengan aturan database.
7. Jika ada fitur yang tidak bisa berjalan karena struktur database atau hak akses, jelaskan masalahnya. Jangan menyelesaikannya dengan menghapus constraint atau menonaktifkan trigger.
B. STRUKTUR DATABASE YANG SUDAH ADA
Database menggunakan tabel berikut.
1. 
accounts
- id
- account_code
- account_name
- account_type
- is_active
Tipe akun yang diperbolehkan adalah ASSET, LIABILITY, EQUITY, REVENUE, dan EXPENSE.
Jangan mengasumsikan bahwa tabel ini memiliki kolom is_cash_bank. Gunakan hanya kolom yang benar-benar tersedia. Jika diperlukan untuk membedakan akun kas/bank, jangan menambah kolom database secara otomatis. Beri tahu saya jika klasifikasi akun tersebut tidak dapat ditentukan dari struktur yang tersedia.
2. cash_vouchers
- id
- voucher_number
- transaction_date
- payee
- description
- status
- created_by
- created_at
- posted_by
- posted_at
- reversal_of
- content_hash
Status voucher hanya DRAFT atau POSTED. Kolom created_by dan posted_by berhubungan dengan auth.users. Voucher yang berstatus POSTED harus memenuhi constraint waktu dan pengguna posting yang sudah ditentukan database.
3. cash_voucher_lines
- id
- voucher_id
- line_number
- account_id
- debit
- credit
- created_at
Setiap baris harus memiliki nomor urut line_number yang valid dan akun yang terdaftar. Nilai debit dan kredit tidak boleh negatif, dan setiap baris hanya boleh memiliki nilai positif pada salah satu sisi. Nomor baris dalam satu voucher harus unik.
4. audit_logs
- id
- voucher_id
- actor_id
- action
- event_at
- details
- previous_hash
- event_hash
Audit log dibuat oleh trigger/function database. Tabel ini memiliki perlindungan agar catatan audit tidak dapat diubah atau dihapus secara sembarangan.
C. PERBAIKI INTEGRASI FRONTEND
Periksa seluruh kode yang sudah ada dan perbaiki masalah berikut jika memang ditemukan.
1. Pemetaan data akun
- Gunakan account_code, account_name, dan account_type sesuai nama kolom database.
- Jangan menggunakan code, name, atau type untuk membaca hasil query database kecuali memang dibuat sebagai alias yang jelas.
- Ambil akun aktif dari Supabase.
- Tampilkan kode dan nama akun dengan benar pada dropdown maupun tabel jurnal.
2. Form voucher
- Pastikan nomor voucher, tanggal transaksi, penerima, deskripsi, dan status dipetakan ke kolom database yang sesuai.
- Pastikan setiap baris jurnal memiliki line_number, account_id, debit, dan credit.
- Jangan mengirim kolom yang tidak ada di database.
- Jangan mengasumsikan bahwa akun kas/bank dapat diidentifikasi hanya dari account_type = ASSET. Jika belum ada penanda khusus, pertahankan pilihan akun yang tersedia dan jelaskan keterbatasan validasi akun kas/bank.
3. Proses simpan voucher
- Pertahankan konsep voucher DRAFT dan POSTED.
- Validasi di frontend harus memeriksa kelengkapan data, minimal dua baris jurnal, nilai debit dan kredit yang benar, serta keseimbangan total debit dan kredit.
- Validasi frontend tidak menggantikan validasi database.
- Perhatikan bahwa penyimpanan header voucher dan baris jurnal melalui dua operasi terpisah berisiko meninggalkan header tanpa baris jurnal jika operasi kedua gagal.
- Periksa apakah tersedia RPC/function database yang memang dirancang untuk menyimpan header dan seluruh baris secara atomik. Gunakan hanya function yang benar-benar tersedia dan sesuai parameternya.
- Jika belum tersedia, jangan mengarang nama function atau menganggap transaksi frontend otomatis atomik. Jelaskan keterbatasan tersebut dan pertahankan struktur database saat ini.
- Jika penyimpanan baris gagal setelah header berhasil disimpan, tampilkan pesan error yang jelas dan jangan memberi tahu pengguna bahwa transaksi berhasil sepenuhnya.
4. Proses posting
- Jangan langsung mengubah status voucher menjadi POSTED jika aplikasi tidak dapat memenuhi persyaratan database.
- Perhatikan kebutuhan posted_by dan posted_at.
- Jangan mengarang UUID pengguna atau mengisi created_by/posted_by dengan nilai sembarang.
- Jangan melewati trigger, constraint, atau validasi posting yang sudah tersedia.
- Jika aplikasi belum memiliki autentikasi Supabase yang sesungguhnya, jelaskan bahwa proses posting mungkin membutuhkan penyesuaian autentikasi atau function backend yang aman. Jangan mengekspos service_role key di frontend.
5. Dashboard
- Perbaiki perhitungan total kas keluar.
- Jangan menghitung kas keluar dengan menjumlahkan seluruh debit jurnal lalu membaginya dengan dua.
- Gunakan data voucher berstatus POSTED dan identifikasi transaksi kas/bank berdasarkan informasi akun yang benar-benar tersedia.
- Jika akun kas/bank belum dapat diidentifikasi secara pasti, jangan menampilkan angka seolah-olah sudah akurat. Jelaskan keterbatasannya.
6. Audit log
- Jangan memasukkan audit log secara manual dari frontend jika event tersebut sudah ditangani oleh trigger/function database.
- Sesuaikan query audit dengan nama kolom yang tersedia, khususnya event_at, bukan mengasumsikan created_at.
- Jika ingin menampilkan nomor voucher, gunakan relasi/join dengan cash_vouchers.
- Jangan mengubah atau menghapus catatan audit.
7. Pembalikan voucher (reversal)
- Periksa implementasi reversal yang sudah ada.
- Jika database menyediakan function create_cash_voucher_reversal, gunakan function tersebut hanya jika akses, parameter, dan alur pemanggilannya benar-benar sesuai.
- Parameter p_original_voucher_id harus berupa ID numerik voucher asli, bukan nomor voucher berupa teks.
- Jangan membuat reversal dengan langsung menyisipkan voucher POSTED jika bertentangan dengan aturan database.
- Jangan memberikan hak akses tambahan secara sembarangan.
- Jika reversal tidak dapat diintegrasikan dengan aman dari frontend, pertahankan tampilan fiturnya tetapi berikan pesan bahwa proses belum dapat dilakukan, daripada menghasilkan data yang salah.
8. Keamanan dan error handling
- Tangani error dari Supabase dan tampilkan pesan yang mudah dipahami.
- Jangan menampilkan notifikasi sukses sebelum operasi database benar-benar berhasil.
- Jangan memasukkan nilai dari pengguna ke innerHTML tanpa pengamanan yang sesuai.
- Jangan menonaktifkan constraint atau trigger demi membuat aplikasi terlihat berjalan.
- Jangan menaruh Supabase service_role key di frontend. Gunakan hanya publishable/anon key yang sesuai dan perhatikan izin akses database yang tersedia.
D. CARA KERJA YANG SAYA INGINKAN
1. Periksa kode index.html yang sudah ada terlebih dahulu.
2. Identifikasi bagian yang bermasalah dan perbaiki langsung pada kode tersebut.
3. Pertahankan semua bagian desain dan fitur yang tidak bermasalah.
4. Pastikan nama tabel dan kolom pada setiap query sesuai struktur database di atas.
5. Jangan mengarang tabel, kolom, RPC, function, atau trigger yang belum diketahui tersedia.
6. Jika ada informasi database yang belum cukup untuk membuat suatu fitur benar-benar berfungsi, beri tahu saya secara spesifik dan jangan menebak.
7. Jangan hanya memberikan potongan kode atau penjelasan. Saya membutuhkan kode index.html hasil revisi secara lengkap, agar dapat langsung saya gunakan untuk menggantikan kode sebelumnya.
8. Setelah kode selesai, berikan daftar perubahan yang dilakukan dan urutan pengujian singkat di Supabase serta browser.
Prioritas saya adalah menyelesaikan tugas UTS menggunakan frontend yang sudah ada dan database yang sudah tersedia. Saya lebih memilih fitur yang benar-benar berfungsi dengan integritas data yang terjaga daripada fitur yang terlihat lengkap tetapi menghasilkan data akuntansi yang salah.