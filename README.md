# Identitas Mahasiswa
Nama         : Yaumi Maghfiroh

NIM          : 12030124130168

Mata Kuliah  : Pengkodean dan Pemrograman - E

## Web Demo dan Repository

**Web Demo:**
[(https://yaumifirh.github.io/UTS_Pengkodean_Yaumi_Maghfiroh/)]

**GitHub Repository:**
[https://github.com/yaumifirh/UTS_Pengkodean_Yaumi_Maghfiroh/]

# Voucher Entri Transaksi Kas Keluar

**Aplikasi Web Sistem Informasi Akuntansi — UTS**

## 1. Deskripsi Proyek

Voucher Entri Transaksi Kas Keluar merupakan aplikasi web yang dirancang untuk membantu proses pencatatan transaksi pengeluaran kas dalam suatu entitas bisnis. Aplikasi ini berfokus pada pencatatan voucher, pengelolaan akun, penyusunan jurnal debit dan kredit, serta pengendalian transaksi melalui validasi pada sisi aplikasi dan database.

Aplikasi dikembangkan dengan frontend berbasis HTML, CSS, dan JavaScript, serta menggunakan Supabase sebagai layanan backend dengan PostgreSQL sebagai sistem manajemen basis data relasional.

Proyek ini dibuat sebagai implementasi konsep Sistem Informasi Akuntansi, khususnya dalam proses pencatatan transaksi kas keluar, integritas data akuntansi, dan jejak audit (*audit trail*).

## 2. Tujuan Pengembangan

Tujuan pengembangan aplikasi ini adalah:

1. Mendigitalisasi proses pencatatan voucher transaksi kas keluar.
2. Memfasilitasi pencatatan jurnal dengan sistem debit dan kredit.
3. Mengintegrasikan aplikasi web dengan database PostgreSQL melalui Supabase.
4. Menjaga konsistensi transaksi melalui constraint, function, dan trigger database.
5. Menyediakan mekanisme pencatatan aktivitas untuk mendukung penelusuran perubahan transaksi.
6. Menerapkan konsep pengendalian internal dalam proses pencatatan dan posting voucher.

## 3. Teknologi yang Digunakan

| Teknologi    | Fungsi                                                                                |
| ------------ | ------------------------------------------------------------------------------------- |
| HTML         | Menyusun struktur halaman aplikasi.                                                   |
| CSS          | Mengatur tata letak, warna, tipografi, dan tampilan antarmuka.                        |
| JavaScript   | Mengatur interaksi pengguna, validasi form, serta komunikasi frontend dengan backend. |
| Supabase     | Menyediakan layanan database dan akses data melalui API.                              |
| PostgreSQL   | Menyimpan data akun, voucher, baris jurnal, dan audit log.                            |
| GitHub       | Menyimpan kode sumber dan dokumentasi proyek.                                         |
| GitHub Pages | Mempublikasikan frontend sebagai web demo statis.                                     |

## 4. Fitur Aplikasi

### 4.1. Pengelolaan Akun

Aplikasi menggunakan data akun yang tersimpan dalam tabel `accounts`. Data akun mencakup kode akun, nama akun, tipe akun, dan status aktif.

Informasi akun digunakan untuk mendukung pemilihan akun dalam pencatatan jurnal transaksi.

### 4.2. Entri Voucher Kas Keluar

Voucher digunakan sebagai dokumen pencatatan transaksi pengeluaran kas. Data utama voucher meliputi:

* Nomor voucher.
* Tanggal transaksi.
* Penerima pembayaran (*payee*).
* Deskripsi transaksi.
* Status voucher.
* Informasi waktu dan pengguna terkait pencatatan serta posting.

Data header voucher disimpan dalam tabel `cash_vouchers`.

### 4.3. Pencatatan Jurnal Debit dan Kredit

Setiap voucher dapat memiliki beberapa baris jurnal. Setiap baris mencatat akun yang digunakan, nomor urut baris, nilai debit, dan nilai kredit.

Baris jurnal disimpan dalam tabel `cash_voucher_lines` dan dihubungkan dengan voucher melalui `voucher_id`.

Secara akuntansi, transaksi kas keluar umumnya mencatat kredit pada akun kas atau bank dan debit pada akun yang menjadi lawan transaksi. Kebenaran pemilihan akun tetap perlu divalidasi sesuai jenis transaksi.

### 4.4. Validasi Transaksi

Validasi dilakukan untuk membantu menjaga kualitas pencatatan, termasuk:

* Kelengkapan informasi voucher.
* Penggunaan akun yang terdaftar.
* Nilai debit dan kredit yang tidak negatif.
* Penggunaan salah satu sisi debit atau kredit pada setiap baris.
* Keseimbangan total debit dan kredit sebelum voucher diposting.
* Pemenuhan ketentuan jumlah baris jurnal dan persyaratan posting.

Validasi frontend membantu pengguna, sedangkan constraint dan trigger database berfungsi sebagai lapisan pengendalian tambahan.

### 4.5. Status Voucher

Database mendukung dua status voucher:

* **DRAFT:** voucher masih dalam tahap penyusunan.
* **POSTED:** voucher telah melewati proses posting dan memenuhi ketentuan database.

Voucher yang telah berstatus `POSTED` dilindungi dari perubahan atau penghapusan melalui mekanisme pengendalian database yang telah dikonfigurasi.

### 4.6. Audit Trail

Aplikasi menggunakan tabel `audit_logs` untuk menyimpan catatan aktivitas yang berkaitan dengan voucher dan baris jurnal.

Informasi audit mencakup jenis aktivitas, waktu kejadian, pengguna terkait, detail peristiwa, serta nilai hash untuk mendukung penelusuran integritas catatan.

Aktivitas yang didukung oleh mekanisme audit mencakup pembuatan voucher, perubahan tertentu, posting, dan pembalikan voucher. Perubahan baris jurnal juga dapat dicatat melalui trigger terkait.

### 4.7. Pembalikan Voucher (*Reversal*)

Database menyediakan function `create_cash_voucher_reversal` untuk membentuk voucher pembalikan dari voucher asli yang telah diposting, dengan membalik nilai debit dan kredit pada baris jurnal.

Mekanisme ini dimaksudkan untuk mendukung koreksi melalui pencatatan transaksi pembalik tanpa mengubah voucher asli yang telah diposting.

Ketersediaan function pada database tidak otomatis berarti fitur reversal sudah dapat dipanggil melalui antarmuka. Penggunaan dari frontend bergantung pada integrasi function dan izin akses yang sesuai.

## 5. Struktur Database

Database menggunakan PostgreSQL melalui Supabase. Struktur utamanya terdiri atas empat tabel berikut.

### 5.1. Tabel `accounts`

Menyimpan daftar akun yang dapat digunakan dalam pencatatan jurnal.

| Kolom          | Fungsi                      |
| -------------- | --------------------------- |
| `id`           | Primary key akun.           |
| `account_code` | Kode akun yang unik.        |
| `account_name` | Nama akun.                  |
| `account_type` | Klasifikasi akun.           |
| `is_active`    | Menandai apakah akun aktif. |

Nilai `account_type` dibatasi pada `ASSET`, `LIABILITY`, `EQUITY`, `REVENUE`, dan `EXPENSE`.

### 5.2. Tabel `cash_vouchers`

Menyimpan informasi utama voucher transaksi kas keluar.

| Kolom              | Fungsi                                         |
| ------------------ | ---------------------------------------------- |
| `id`               | Primary key voucher.                           |
| `voucher_number`   | Nomor voucher yang unik.                       |
| `transaction_date` | Tanggal transaksi.                             |
| `payee`            | Penerima pembayaran.                           |
| `description`      | Deskripsi transaksi.                           |
| `status`           | Status `DRAFT` atau `POSTED`.                  |
| `created_by`       | Referensi pengguna pembuat.                    |
| `created_at`       | Waktu pembuatan voucher.                       |
| `posted_by`        | Referensi pengguna yang melakukan posting.     |
| `posted_at`        | Waktu posting.                                 |
| `reversal_of`      | Referensi voucher asli yang dibalik, jika ada. |
| `content_hash`     | Kolom hash konten yang disediakan dalam skema. |

Constraint pada tabel ini mencakup keunikan nomor voucher, referensi voucher pembalik, serta ketentuan waktu dan pengguna posting.

### 5.3. Tabel `cash_voucher_lines`

Menyimpan rincian jurnal dari setiap voucher.

| Kolom         | Fungsi                          |
| ------------- | ------------------------------- |
| `id`          | Primary key baris jurnal.       |
| `voucher_id`  | Foreign key ke `cash_vouchers`. |
| `line_number` | Nomor urut baris jurnal.        |
| `account_id`  | Foreign key ke `accounts`.      |
| `debit`       | Nilai debit.                    |
| `credit`      | Nilai kredit.                   |
| `created_at`  | Waktu pembuatan baris jurnal.   |

Constraint pada tabel ini mengatur nomor baris yang valid, keunikan nomor baris dalam satu voucher, nilai debit dan kredit yang tidak negatif, serta ketentuan bahwa satu baris hanya memiliki nilai positif pada salah satu sisi.

### 5.4. Tabel `audit_logs`

Menyimpan catatan aktivitas audit.

| Kolom           | Fungsi                                       |
| --------------- | -------------------------------------------- |
| `id`            | Primary key catatan audit.                   |
| `voucher_id`    | Referensi voucher terkait.                   |
| `actor_id`      | Referensi pengguna yang melakukan aktivitas. |
| `action`        | Jenis aktivitas audit.                       |
| `event_at`      | Waktu kejadian.                              |
| `details`       | Detail aktivitas dalam format JSONB.         |
| `previous_hash` | Hash catatan sebelumnya.                     |
| `event_hash`    | Hash catatan saat ini.                       |

Jenis aktivitas dibatasi pada `CREATE`, `UPDATE`, `POST`, `REVERSAL`, dan `REJECTED`.

## 6. Relasi Antar-Tabel

Relasi utama database adalah:

* Satu akun pada `accounts` dapat digunakan pada banyak baris jurnal di `cash_voucher_lines`.
* Satu voucher pada `cash_vouchers` dapat memiliki beberapa baris jurnal di `cash_voucher_lines`.
* Satu voucher dapat memiliki catatan aktivitas di `audit_logs`.
* Voucher pembalik dapat merujuk ke voucher asli melalui kolom `reversal_of`.

Relasi tersebut menggunakan primary key dan foreign key untuk menjaga keterhubungan data.

## 7. Function dan Trigger Database

Database memiliki sejumlah function dan trigger untuk mendukung validasi dan pengendalian transaksi.

### Function utama

* `audit_cash_voucher_event()`: mencatat aktivitas tertentu pada header voucher.
* `audit_cash_voucher_line_event()`: mencatat perubahan pada baris jurnal.
* `create_cash_voucher_reversal(...)`: membentuk voucher pembalik dari voucher asli yang memenuhi syarat.
* `prevent_audit_log_changes()`: mencegah perubahan atau penghapusan catatan audit melalui operasi yang dilindungi.
* `prevent_posted_voucher_changes()`: mencegah perubahan atau penghapusan voucher yang telah diposting.
* `prevent_posted_voucher_line_changes()`: mencegah perubahan yang tidak diperbolehkan pada baris jurnal voucher yang telah diposting.
* `validate_voucher_before_posting()`: memvalidasi jurnal sebelum status berubah menjadi `POSTED`.
* `write_audit_log(...)`: menulis catatan audit dengan informasi hash dan referensi hash sebelumnya.

### Tujuan trigger

Trigger menghubungkan aktivitas pada tabel dengan function yang sesuai. Implementasinya meliputi validasi sebelum posting, perlindungan terhadap voucher yang telah diposting, pencatatan aktivitas audit, dan perlindungan terhadap perubahan catatan audit.

Dengan demikian, aturan penting tidak hanya bergantung pada perilaku antarmuka pengguna.

## 8. Alur Kerja Sistem

Secara umum, alur transaksi yang dirancang adalah:

1. Pengguna membuka aplikasi.
2. Pengguna mengakses form voucher.
3. Pengguna memasukkan informasi transaksi.
4. Pengguna memilih akun dan mengisi rincian debit serta kredit.
5. Sistem memeriksa kelengkapan dan keseimbangan jurnal.
6. Data voucher dan baris jurnal dikirim ke Supabase sesuai proses integrasi yang tersedia.
7. Voucher dapat diposting jika memenuhi validasi dan persyaratan database.
8. Aktivitas yang relevan dicatat dalam audit log oleh mekanisme database.
9. Voucher yang telah diposting dilindungi dari perubahan yang tidak diperbolehkan.

Implementasi aktual setiap langkah bergantung pada fitur frontend dan izin akses yang telah dikonfigurasi.

## 9. Integritas Data dan Pengendalian Internal

Beberapa mekanisme yang diterapkan pada database meliputi:

* Primary key dan foreign key untuk menjaga identitas dan relasi data.
* Unique constraint untuk mencegah duplikasi nomor voucher dan nomor baris jurnal.
* Check constraint untuk membatasi nilai dan status yang diperbolehkan.
* Validasi keseimbangan debit dan kredit sebelum posting.
* Perlindungan voucher yang telah diposting dari perubahan yang tidak diperbolehkan.
* Audit trail untuk membantu penelusuran aktivitas.
* Hash berantai pada catatan audit untuk mendukung pemeriksaan integritas catatan.

Hash berantai merupakan salah satu mekanisme pendukung integritas, bukan jaminan keamanan mutlak. Efektivitasnya tetap bergantung pada konfigurasi hak akses, perlindungan database, dan implementasi fungsi audit.

## 10. Keamanan dan Konfigurasi

Aplikasi menggunakan Supabase sebagai layanan backend. Konfigurasi frontend menggunakan Project URL dan publishable key atau legacy anon key yang sesuai.

Informasi rahasia seperti `service_role` key dan secret key tidak boleh ditempatkan pada kode frontend atau repository publik.

Akses data harus disesuaikan dengan autentikasi, hak akses, dan kebijakan Row Level Security (RLS). Status koneksi berhasil saja tidak menjamin semua operasi baca dan tulis telah diizinkan.

## 11. Cara Menjalankan

### Menjalankan secara lokal

1. Unduh atau clone repository.
2. Buka file `index.html` melalui browser atau server lokal.
3. Pastikan konfigurasi Supabase menggunakan Project URL dan publishable/anon key yang benar.
4. Pastikan project Supabase memiliki tabel, function, trigger, dan izin akses yang dibutuhkan aplikasi.
5. Uji fitur aplikasi dan periksa error melalui browser Developer Tools jika diperlukan.

### Mengakses web demo

Buka URL GitHub Pages yang tercantum pada bagian Web Demo. GitHub Pages digunakan untuk menyajikan frontend statis, sedangkan penyimpanan dan pemrosesan data dilakukan melalui Supabase.

## 12. Batasan Implementasi

Beberapa aspek perlu diverifikasi dalam pengujian aplikasi, antara lain:

* Kesesuaian seluruh query frontend dengan struktur database.
* Keberhasilan penyimpanan header dan baris jurnal.
* Penanganan kegagalan saat penyimpanan beberapa bagian transaksi.
* Kesesuaian hak akses autentikasi dan posting.
* Ketepatan identifikasi akun kas/bank untuk pelaporan kas keluar.
* Integrasi function reversal dengan antarmuka pengguna.
* Ketepatan data dashboard berdasarkan transaksi yang telah diposting.

Pengujian tersebut diperlukan untuk memastikan aplikasi tidak hanya dapat dibuka, tetapi juga menghasilkan pencatatan yang konsisten.

---

**Proyek UTS — Sistem Informasi Akuntansi**
