Prompt NotebookLM — Verifikasi Logika Akuntansi

Bertindaklah sebagai pemeriksa logika bisnis aplikasi akuntansi. Gunakan dokumen standar akuntansi yang saya tambahkan sebagai sumber utama dan periksa kode aplikasi "Voucher Entri Transaksi Kas Keluar" yang saya lampirkan.

Tujuan pemeriksaan adalah mengevaluasi kesesuaian logika kode dengan ketentuan akuntansi terkait kas dan setara kas serta pencatatan transaksi kas keluar.

Periksa hal-hal berikut:

1. Apakah akun kas dan bank dibedakan secara jelas dari akun beban, utang, modal, dan pendapatan?
2. Apakah logika jurnal transaksi kas keluar mencatat debit pada akun yang sesuai dan kredit pada akun kas atau bank yang digunakan untuk pembayaran?
3. Apakah sistem memastikan total debit sama dengan total kredit sebelum transaksi dapat disimpan atau diposting?
4. Apakah perhitungan nilai transaksi kas keluar pada dashboard didasarkan pada nilai kredit akun kas atau bank, bukan sekadar total debit jurnal?
5. Apakah validasi pada formulir didukung oleh validasi database agar transaksi yang tidak valid tidak dapat diposting?

Sajikan hasil dalam tabel yang berisi:

* Aturan atau prinsip akuntansi yang relevan.
* Bukti dari sumber standar beserta halaman atau paragraf jika tersedia.
* Perilaku yang ditemukan dalam kode.
* Status kesesuaian: sesuai, tidak sesuai, atau belum dapat dipastikan.
* Alasan dan rekomendasi perbaikan.

Bedakan temuan kepatuhan akuntansi dari temuan teknis pemrograman. Jangan mengarang nomor paragraf standar atau menyatakan kode sepenuhnya mematuhi PSAK apabila bukti tidak cukup. Jika suatu ketentuan tidak dapat diverifikasi dari dokumen yang tersedia, nyatakan keterbatasannya secara jelas.

Akhiri dengan ringkasan hasil verifikasi dan kesimpulan mengenai bagian kode yang sudah sesuai serta bagian yang masih memerlukan perbaikan.
