#!/bin/bash

# Mathar AR Quiz Uygulamasını iOS cihazda çalıştırma betiği
echo "Mathar AR Quiz Uygulaması iOS Başlatma Betiği"
echo "----------------------------------------------"

# Flutter bağımlılıklarını güncelliyoruz
echo "Flutter bağımlılıkları kontrol ediliyor..."
flutter pub get

# iOS için pod'ları kuruyoruz
echo "iOS pod'ları yükleniyor..."
cd ios && pod install --repo-update && cd ..

# Bağlı cihazları kontrol ediyoruz
echo "Bağlı iOS cihazlar kontrol ediliyor..."
flutter devices

# iOS cihazlarını alıyoruz
IOS_DEVICES=$(flutter devices | grep -i ios | cut -d "•" -f2)

if [ -z "$IOS_DEVICES" ]; then
  echo "Bağlı iOS cihaz bulunamadı!"
  echo "Lütfen bir iOS cihaz bağlayın ve tekrar deneyin."
  exit 1
fi

echo "Tespit edilen iOS cihazlar:"
echo "$IOS_DEVICES"

# Kullanıcıya soralım
echo ""
echo "Uygulamayı çalıştırmak istiyor musunuz? (E/h)"
read -r response
if [[ "$response" =~ ^([hH][aA][yY][ıI][rR]|[hH])$ ]]; then
  echo "İşlem iptal edildi."
  exit 0
fi

# Uygulamayı çalıştırıyoruz
echo "Uygulama iOS cihazda başlatılıyor..."
flutter run -d ios

echo "Uygulama çalıştırılıyor. Çıkmak için 'q' tuşuna basabilirsiniz." 