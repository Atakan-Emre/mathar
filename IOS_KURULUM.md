# iOS Cihazlarda Mathar AR Quiz Uygulamasını Çalıştırma

## iOS için Ön Gereksinimler

- **Donanım:** ARKit destekleyen bir iOS cihaz (iPhone 6S veya sonrası, A9 işlemci veya üzeri)
- **Yazılım:** iOS 11.0 veya daha yeni
- **Geliştirme Ortamı:** macOS, Xcode 13.0+ ve Flutter SDK

## Adım Adım iOS Kurulum Süreci

### 1. Geliştirici Hesabını Yapılandırma

Xcode'da Apple ID hesabınızı ekleyin:
1. Xcode'u açın
2. Xcode → Preferences → Accounts
3. Sol alt köşedeki "+" düğmesine tıklayın
4. Apple ID ile giriş yapın

### 2. iOS Projesini Derleme ve Çalıştırma

#### Terminal ile Çalıştırma:

```bash
# Proje klasörüne gidin
cd mathar

# Bağımlılıkları yükleyin
flutter pub get

# iOS için derleyin ve çalıştırın
flutter run -d ios
```

#### Xcode ile Manuel Çalıştırma:

1. iOS proje klasörünü Xcode ile açın:
```bash
cd mathar
open ios/Runner.xcworkspace
```

2. Xcode'da aşağıdaki ayarları yapın:
   - Sol üstteki cihaz seçici menüden fiziksel iOS cihazınızı seçin
   - "Runner" projesini seçin (sol taraftaki Navigator'da)
   - "Signing & Capabilities" sekmesini açın
   - "Team" altında Apple geliştirici hesabınızı seçin

3. Play düğmesine tıklayarak uygulamayı derleyin ve çalıştırın

### 3. Olası Sorunlar ve Çözümleri

#### Modeller Yüklenemiyor veya AR Çalışmıyor

Mathar uygulaması şu anda modeller olmadan çalışacak şekilde programlanmıştır. AR görünümünde:
1. "Doğrudan Quiz'e Geç" düğmesine basın
2. Quiz soruları normal şekilde çalışacaktır

#### iOS Signing Hataları

```
Error: No valid code signing certificates were found
```

Çözüm:
1. Xcode → Preferences → Accounts → [Apple ID'niz] → Manage Certificates
2. "+" düğmesine tıklayarak yeni bir "iOS Development" sertifikası oluşturun
3. Runner.xcworkspace'de "Automatically manage signing" seçeneğini işaretleyin

#### Bundle Identifier Sorunları

Benzersiz bir bundle identifier gerekiyorsa:
1. Xcode'da Runner projesini açın
2. "General" sekmesinde "Bundle Identifier" alanını düzenleyin (örneğin: "com.sizinisminiz.mathar")

#### Info.plist Sorunları

Camera kullanımı izinleri için gerekli olan bilgiyi doğrulayın:
1. Runner/Info.plist dosyasını açın
2. `NSCameraUsageDescription` anahtarının var olduğunu ve uygun bir açıklama içerdiğini kontrol edin

## Model Klasörü Yapılandırması

AR deneyimini geliştirmek için kendi modellerinizi oluşturabilir ve dahil edebilirsiniz:

1. Aşağıdaki dosya adlarını kullanarak modeller hazırlayın:
   - `kare.glb` / `kare.usdz`
   - `ucgen.glb` / `ucgen.usdz`
   - `daire.glb` / `daire.usdz`
   - `kure.glb` / `kure.usdz`

2. Bu modelleri `assets/models/` klasörüne yerleştirin

3. iOS'ta USDZ formatı daha iyi performans sağlar

## Test Edilmiş Çalışma Ortamları

- iOS 16.0+ / iPhone 13 veya sonrası
- iOS 14.0+ / iPhone X veya sonrası
- iOS 13.0+ / iPhone 8 veya sonrası
- iOS 11.0+ / iPhone 6S ve iPhone 7 (daha düşük performans) 