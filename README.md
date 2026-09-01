# Engineering Records

Repository pribadi untuk mendokumentasikan engineering decisions, requirements,
architecture, integration, verification, validation, dan lessons learned dari
fitur/proyek yang dikerjakan.

## Structure

- `template/` — template engineering record
- `records/` — record per project/feature
- `assets/` — shared assets
- `build/` — generated LaTeX output; ignored by Git

## Requirements

Pastikan tool berikut tersedia:

- GNU Make
- `latexmk`
- TeX Live beserta package LaTeX yang digunakan template

## Using the Makefile

Jalankan seluruh command dari root repository.

### Create a new record

```bash
make new PROJECT="Optimasi Reconnect Behavior"
```

Gunakan tanda kutip untuk input nama. Nama boleh menggunakan
huruf besar atau kecil, angka, spasi, dan tanda hubung.

```text
records/optimasi-reconnect-behavior/
├── main.tex
└── figures/
```

Pembuatan akan dibatalkan jika nama project tidak valid, template tidak ditemukan,
atau folder project sudah ada.

### Build the template

```bash
make build
```

Hasil build template disimpan di `build/template/`.

### Build a record

```bash
make build DOCUMENT=records/project-a/main.tex
```

Hasilnya disimpan di `build/records/project-a/`. File generated seperti PDF,
`.aux`, `.log`, `.fls`, dan `.synctex.gz` tidak ditulis ke folder source.

### Clean generated files

Membersihkan hasil build template:

```bash
make clean
```

Membersihkan hasil build record tertentu:

```bash
make clean DOCUMENT=records/project-a/main.tex
```

### Remove a record

```bash
make remove PROJECT=project-a
```

Karena operasi ini menghapus source, command akan meminta nama project diketik
ulang sebagai konfirmasi. Jika cocok, `records/project-a/` dan hasil build pada
`build/records/project-a/` akan dihapus. Operasi dibatalkan jika record tidak
ditemukan atau konfirmasi tidak cocok.

`make clean` dan `make remove` memiliki fungsi berbeda: `clean` hanya menghapus
hasil kompilasi, sedangkan `remove` menghapus record beserta hasil build-nya.

## Typical workflow

```bash
make new PROJECT=project-a
make build DOCUMENT=records/project-a/main.tex
```

Setelah record dibuat, edit `records/project-a/main.tex`. Jangan mengedit master
template untuk menyimpan isi project tertentu.

Build melalui LaTeX Workshop tetap dapat digunakan. Konfigurasi workspace di
`.vscode/settings.json` mengarahkan hasilnya ke struktur `build/` yang sama,
meskipun LaTeX Workshop tidak menjalankan Makefile secara langsung.
