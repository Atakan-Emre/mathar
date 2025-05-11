# iOS ve Android için Mathar AR Uygulaması Kurulum Talimatları

## iOS için Kurulum

1. **Gerekli Araçlar**
   - macOS bilgisayar
   - Xcode 13.0 veya üzeri
   - iOS 11.0 veya üzeri yüklü fiziksel bir iPhone/iPad (A9 işlemci veya üzeri)
   - Apple Geliştirici Hesabı (ücretsiz veya ücretli)

2. **Proje Ayarları**
   - Terminal'de proje klasörüne gidin
   ```bash
   cd mathar
   ```
   - Flutter bağımlılıklarını yükleyin
   ```bash
   flutter pub get
   ```

3. **iOS Simulator ile Test**
   - Not: AR özellikleri simulator'da çalışmaz, sadece UI test edilebilir
   ```bash
   flutter run -d simulator
   ```

4. **Fiziksel Cihazda Çalıştırma**

   a) Xcode ile Kurulum:
   ```bash
   open ios/Runner.xcworkspace
   ```
   
   b) Xcode'da:
   - Sol üstteki cihaz listesinden fiziksel cihazınızı seçin
   - Runner hedefini seçin
   - "Signing & Capabilities" sekmesinde takımınızı seçin
   - Build & Run (Play) tuşuna basın

   c) Alternatif olarak Terminal ile:
   ```bash
   flutter run -d ios
   ```

5. **Olası Hatalar ve Çözümleri**

   a) Signing Hatası:
   - Xcode'da "Automatically manage signing" seçeneğini işaretleyin
   - Apple ID ile giriş yapın

   b) ARKit Hatası:
   - Fiziksel cihazınızın ARKit'i desteklediğinden emin olun (A9 işlemci veya üzeri)
   - iOS 11 veya üzeri olduğundan emin olun

   c) Model Dosyaları Hatası:
   - Modelleri gerçekten yüklemek için `assets/models/` klasörüne gerekli dosyaları ekleyin
   - Uygulama modeller olmadan da çalışacak şekilde ayarlandı

## Android için Kurulum

1. **Gerekli Araçlar**
   - Android Studio
   - Android SDK (API Level 24 veya üzeri)
   - ARCore destekleyen Android cihaz

2. **Proje Ayarları**
   - Terminal'de proje klasörüne gidin
   ```bash
   cd mathar
   ```
   - Flutter bağımlılıklarını yükleyin
   ```bash
   flutter pub get
   ```

3. **Android Emülatör ile Test**
   - Not: AR özellikleri çoğu emülatörde çalışmaz, sadece UI test edilebilir
   ```bash
   flutter run -d emulator
   ```

4. **Fiziksel Cihazda Çalıştırma**
   ```bash
   flutter run -d android
   ```

5. **Olası Hatalar ve Çözümleri**
   
   a) ARCore Hatası:
   - Cihazınızın ARCore'u desteklediğinden emin olun
   - Google Play Services for AR uygulamasının yüklü olduğundan emin olun

   b) Permissions Hatası:
   - Uygulamanın kamera izinlerinin verildiğinden emin olun

   c) Model Dosyaları Hatası:
   - Modelleri gerçekten yüklemek için `assets/models/` klasörüne gerekli dosyaları ekleyin
   - Uygulama modeller olmadan da çalışacak şekilde ayarlandı 