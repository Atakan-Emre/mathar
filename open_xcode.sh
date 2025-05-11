#!/bin/bash

# Mathar AR Quiz Uygulamasını Xcode ile açma betiği
echo "Mathar AR Quiz Uygulaması Xcode Açma Betiği"
echo "-------------------------------------------"

# Flutter bağımlılıklarını güncelliyoruz
echo "Flutter bağımlılıkları kontrol ediliyor..."
flutter pub get

# iOS için pod'ları kuruyoruz
echo "iOS pod'ları yükleniyor..."
cd ios && pod install --repo-update && cd ..

# Xcode ile açıyoruz
echo "Xcode ile proje açılıyor..."
open ios/Runner.xcworkspace

echo "Xcode açıldı! Projeyi çalıştırmak için:"
echo "1. Sol üstten cihazınızı seçin"
echo "2. Signing ayarlarını yapın (Team seçin)"
echo "3. Play tuşuna basın"
echo ""
echo "Not: AR özellikleri için fiziksel bir iOS cihaz gereklidir." 