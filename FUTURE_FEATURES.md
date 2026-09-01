# Future Features

Dokumen ini menyimpan konsep fitur yang belum diimplementasikan.

## Autocomplete untuk command Makefile

**Status:** Konsep

### Tujuan

Menyediakan Bash completion yang memahami struktur repository sehingga penggunaan
command Makefile lebih cepat dan tidak bergantung pada hafalan nama target atau
path record.

### Perilaku yang diharapkan

- `make <Tab>` menampilkan target seperti `build`, `clean`, `new`, dan `remove`.
- `make remove PROJECT=<Tab>` menampilkan nama folder yang tersedia di `records/`.
- `make build DOCUMENT=<Tab>` menampilkan file `main.tex` milik template dan record.
- `make clean DOCUMENT=<Tab>` menggunakan daftar dokumen yang sama dengan `build`.
- `make new <Tab>` dapat menyarankan penulisan `PROJECT=` tanpa menawarkan record
  yang sudah ada sebagai nama baru.

Contoh:

```text
make remove PROJECT=<Tab>

optimasi-reconnect-behavior  tes2
```

### Rancangan awal

- Simpan implementasi completion di `scripts/completion.bash`.
- Ambil daftar record secara dinamis dari folder `records/`.
- Batasi completion khusus ini agar hanya aktif untuk repository Engineering
  Records dan tidak mengganggu completion `make` di project lain.
- Tetap gunakan completion standar Bash untuk target Makefile yang tidak memiliki
  aturan khusus.
- Dokumentasikan cara aktivasi melalui `~/.bashrc`; repository tidak mengubah
  konfigurasi shell pengguna secara otomatis.

### Kriteria selesai

- Completion target dan parameter bekerja setelah script dimuat ulang.
- Saran `PROJECT=` hanya berisi direktori record yang valid.
- Saran `DOCUMENT=` hanya berisi file LaTeX yang dapat dibangun.
- Nama yang disarankan aman terhadap spasi dan karakter khusus shell.
- Completion tidak membuat, mengubah, atau menghapus record.

### Keputusan yang masih terbuka

- Apakah dukungan awal hanya untuk Bash atau sekaligus mencakup Zsh.
- Apakah aktivasi dilakukan manual dari `~/.bashrc` atau melalui target instalasi
  khusus.
- Apakah daftar target dibaca secara dinamis dari Makefile atau dipertahankan
  secara eksplisit di script completion.

## Publikasi PDF ke direktori record

**Status:** Konsep

### Tujuan

Setelah record berhasil dibangun, sediakan PDF secara otomatis di direktori
record agar dapat langsung dibuka atau di-stream tanpa mencari hasil kompilasi di
direktori `build/`. PDF hasil kompilasi tetap dipertahankan di `build/`.

### Perilaku yang diharapkan

Command berikut:

```bash
make build DOCUMENT=records/optimasi-reconnect-behavior/main.tex
```

menghasilkan dua lokasi PDF:

```text
build/records/optimasi-reconnect-behavior/main.pdf
records/optimasi-reconnect-behavior/main.pdf
```

PDF di `build/` menjadi hasil kompilasi utama. PDF di direktori record merupakan
salinan publikasi yang siap digunakan untuk preview atau streaming.

### Rancangan awal

- Jalankan proses publikasi hanya setelah `latexmk` selesai tanpa error.
- Terapkan fitur hanya untuk `DOCUMENT` di bawah `records/`; build master template
  tidak perlu menulis PDF ke `template/`.
- Salin PDF dari struktur `build/` ke direktori yang sama dengan source
  `main.tex` tanpa memindahkan atau menghapus hasil build.
- Gunakan penulisan atomik, misalnya menyalin ke file sementara lalu menggantinya,
  agar proses streaming tidak membaca PDF yang baru tersalin sebagian.
- Jangan mengganti PDF publikasi lama ketika kompilasi terbaru gagal.
- Tampilkan kedua path PDF setelah build dan publikasi berhasil.

### Kriteria selesai

- Build yang berhasil menghasilkan PDF valid di kedua lokasi.
- Isi PDF di direktori record identik dengan PDF di `build/`.
- Build yang gagal tidak membuat PDF parsial dan tidak merusak PDF publikasi lama.
- Build template tetap bekerja tanpa membuat `template/main.pdf`.
- Path tetap benar saat nama record berbeda atau `DOCUMENT` diberikan sebagai path
  relatif.
- Perilaku `make clean` terhadap PDF publikasi ditetapkan dan didokumentasikan.

### Keputusan yang masih terbuka

- Apakah PDF di direktori record akan disimpan di Git agar bisa ditampilkan dari
  repository, atau hanya menjadi file lokal hasil build.
- Apakah publikasi menggunakan salinan file atau symbolic link. Salinan diperlukan
  jika PDF harus tersedia tanpa direktori `build/`, sedangkan symbolic link
  menghindari duplikasi untuk penggunaan lokal.
- Apakah nama publikasi selalu `main.pdf` atau mengikuti nama record agar lebih
  jelas saat file diunduh.
- Apakah `make clean` ikut menghapus PDF publikasi atau hanya membersihkan
  direktori `build/`.
