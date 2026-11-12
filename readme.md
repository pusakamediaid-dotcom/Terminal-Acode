# Terminal Acode

Fork Acode untuk pengembangan editor kode dan terminal Android sesuai kebutuhan proyek ini.

Repository: [pusakamediaid-dotcom/Terminal-Acode](https://github.com/pusakamediaid-dotcom/Terminal-Acode).

## Fitur dasar

Kode sumber yang tersedia mencakup:

- Editor kode dan preview halaman web.
- Konsol JavaScript.
- Terminal berbasis Alpine/PRoot.
- Integrasi FTP, SFTP, dan SSH.
- Pengelola plugin dan tema.
- Dukungan berbagai bahasa antarmuka.

Ketersediaan fitur bergantung pada varian build dan konfigurasi. Kompatibilitas plugin serta layanan eksternal perlu diuji pada APK hasil build sendiri.

## Status build dan instalasi

Workflow **Review APK** (`.github/workflows/review-apk.yml`) membangun APK debug melalui GitHub Actions. Build otomatis berjalan saat perubahan kode di-push ke branch review saat ini. Setelah workflow tersedia di default branch, build juga dapat dijalankan melalui **Run workflow**.

Buka tab **Actions → Review APK**, pilih run yang berhasil, lalu unduh artifact `terminal-acode-review-…`. Ekstrak ZIP artifact dan install `terminal-acode-review.apk`. Artifact disimpan selama 14 hari. APK belum dianggap berfungsi sampai diuji pada perangkat.

Workflow menggunakan nama **Terminal Acode Review** dan ID `id.pusakamedia.terminalacode.review`, terpisah dari Acode resmi. Perubahan identitas diterapkan pada workspace CI, bukan konfigurasi build lokal. Debug key dapat berubah antar-run; jika update ditolak, backup data aplikasi review sebelum uninstall dan install ulang.

Untuk diagnosis penyimpanan, jalankan `acode-storage` atau `acode-storage check /sdcard/Download` di terminal. Izin akses semua file harus diaktifkan secara manual melalui pengaturan Android bila tersedia. Izin tersebut tidak otomatis membuka `/Android/data` atau data privat aplikasi lain.

## Build lokal

Diperlukan Git, Node.js/package manager, Java JDK, Android SDK, dan Gradle yang kompatibel. Konfigurasi saat ini menggunakan Cordova Android 15, target Android API 36, dan minimum Android API 26 (Android 8.0).

Dari direktori repository, jalankan:

```bash
# Ambil dependency yang disimpan sebagai submodule.
git submodule update --init --recursive

# Pasang dependency dan siapkan platform Cordova.
pnpm run setup

# Buat APK debug untuk pengujian.
pnpm run build paid dev apk
```

`paid` adalah nama varian build dalam source. APK debug dihasilkan di:

```text
platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

Panduan lingkungan build dan Docker tersedia di [CONTRIBUTING.md](CONTRIBUTING.md). Sebagian panduan tersebut masih merujuk ke proyek upstream; cocokkan persyaratan versi dengan konfigurasi build yang ada di repository ini.

## Struktur proyek

```text
src/                    Kode editor, antarmuka, tema, dan bahasa
src/plugins/            Plugin native Cordova, termasuk terminal dan PRoot
www/                    Aset web dan hasil kompilasi
utils/                  Script setup, konfigurasi, dan build
codemirror-lsp-client/  Submodule untuk integrasi Language Server Protocol
.github/workflows/      Workflow GitHub Actions
```

## Catatan plugin dan data

- Sistem plugin tetap tersedia dalam source; build sendiri tidak otomatis menghapusnya.
- Instalasi dengan application ID berbeda memiliki data terpisah. Plugin dan pengaturan dari Acode resmi tidak otomatis berpindah.
- Marketplace, login, dan pembelian plugin masih bergantung pada layanan eksternal serta hak akses akun. Fork ini tidak menjamin akses atau kompatibilitas seluruh plugin.
- Backup data sebelum mengganti atau menghapus instalasi aplikasi lama.

## Asal proyek dan lisensi

Proyek ini merupakan fork dari [Acode](https://github.com/Acode-Foundation/Acode), bukan rilis resmi upstream.

Kode dasar menggunakan lisensi MIT. Pemberitahuan copyright dan ketentuan lisensi asli tetap dipertahankan di [license.txt](license.txt). Dependency dan komponen pihak ketiga dapat memiliki lisensi tersendiri.
