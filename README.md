# Mathar - AR Matematik Quiz Uygulaması

Mathar, Flutter ile geliştirilen, ARCore ve ARKit kullanarak artırılmış gerçeklik ile matematik öğrenmeyi eğlenceli hale getiren bir mobil uygulamadır. Uygulama, çocukların temel geometrik şekiller (kare, üçgen, daire, küre) hakkındaki matematik bilgilerini interaktif bir ortamda test etmelerini sağlar.

## Özellikler

- Artırılmış gerçeklik (AR) ile 3D geometrik şekilleri görüntüleme
- Dört farklı şekil kategorisi: Kare, Üçgen, Daire ve Küre
- Her kategori için çeşitli matematik soruları
- Görsel ve sesli geri bildirimler
- Doğru cevaplarda konfeti animasyonları
- Çocuk dostu arayüz tasarımı

## Gereksinimler

- Flutter 3.0.0 veya üzeri
- Android: Android 7.0 (API seviye 24) veya üzeri, ARCore destekleyen cihaz
- iOS: iOS 11.0 veya üzeri, ARKit destekleyen cihaz (A9 veya üzeri işlemcili iPhone/iPad)

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/kullaniciadi/mathar.git
```

2. Bağımlılıkları yükleyin:
```bash
cd mathar
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 3D Modeller

Uygulama, açık kaynaklı 3D modeller kullanır. Kendi modellerinizi eklemek için:

1. `.glb` veya `.obj` formatında model dosyalarını `assets/models/` klasörüne ekleyin
2. pubspec.yaml dosyasında assets bölümüne eklediğinizden emin olun

## Katkıda Bulunma

Projeye katkıda bulunmak için lütfen bir pull request gönderin veya önerilerinizi issues bölümünde paylaşın.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır - detaylar için [LICENSE](LICENSE) dosyasına bakın.
