# Akıllı Geri Dönüşüm Sınıflandırma Sistemi ♻️🧠

Bu proje görüntü tabanlı bir otomatik atık sınıflandırma sistemidir.

---

## 📌 Proje Özeti
Bu çalışmada; karton, cam, metal, kâğıt, plastik ve çöp (evsel atık) olmak üzere **6 farklı atık sınıfı** derin öğrenme yöntemleriyle otomatik olarak ayrıştırılmaktadır. Sistem, transfer öğrenme (Transfer Learning) yaklaşımıyla önceden eğitilmiş **ResNet-18** mimarisi kullanılarak MATLAB ortamında geliştirilmiştir. Kullanıcıların sistemi rahatça kullanabilmesi için fonksiyonel bir **Grafik Kullanıcı Arayüzü (GUI)** de entegre edilmiştir.

## 🛠️ Kullanılan Teknolojiler ve Araçlar
* **MATLAB**
* **Deep Learning Toolbox**
* **Image Processing Toolbox**
* **ResNet-18** Derin Öğrenme Modeli

---

## 📁 Veri Seti
Projede Kaggle üzerinde bulunan [Garbage Classification Dataset](https://www.kaggle.com/datasets/mostafaabla/garbage-classification) kullanılmıştır. GitHub dosya boyutu sınırları nedeniyle veri seti klasörü bu depoya dahil edilmemiştir. Projeyi yerelde çalıştırmak için veri setini indirip proje ana dizinine `garbage` adıyla eklemeniz gerekmektedir.

---

## 🚀 Nasıl Çalıştırılır?

1. Bu depoyu bilgisayarınıza indirin (Clone).
2. Orijinal veri setini indirerek proje klasörüne yerleştirin.
3. MATLAB uygulamasını açın.
4. `main.m` dosyasını çalıştırarak GUI arayüzünü (`garbageApp.m`) tetikleyin.
5. Arayüz üzerinden bir test görseli seçebilir veya **Webcam** butonuna tıklayarak canlı olarak sınıflandırma yapabilirsiniz.

---

## 📊 Sonuçlar ve Performans
* Model, test verileri üzerinde yüksek doğruluk oranı (% 99) elde etmiştir.
* Performans analizleri, Karmaşıklık Matrisi (Confusion Matrix) ve Sınıf Bazlı Doğruluk (Recall) metrikleri kullanılarak yapılmıştır.

---

⚠️ Not: Projenin eğitilmiş model dosyası (egitilmisGarbageModel.mat) yüksek boyutu sebebiyle bu depoya dahil edilmemiştir. Projeyi yerelde çalıştırmak için öncelikle modelin yeniden eğitilmesi veya geliştiricilerden temin edilmesi gerekmektedir.

