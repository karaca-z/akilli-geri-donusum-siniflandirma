% PROJE ADI:
% Akıllı Geri Dönüşüm Sınıflandırma Sistemi

%% 1. Veri Setini ve Modeli MATLAB Ortamına Tanıtma
% Bu bölümde çalışma ortamını temizledik.
% Daha önce eğittiğimiz modeli MATLAB'e yükledik
% ve oluşturduğumuz grafik arayüz uygulamasını çalıştırdık.

clear;clc;close all;

% Eğitilmiş modeli .mat dosyasından yüklüyoruz
load("egitilmisGarbageModel.mat");

% Geliştirdiğimiz GUI uygulamasını başlatıyoruz
garbageApp


%% 2. Veri Seti Klasörünün Tanımlanması
% Bu kısımda garbage datasetinin bulunduğu klasör yolunu tanımladık.
% Model eğitimi tamamlandığı için bu satırı tekrar çalıştırmamak adına yorum satırı haline getirdik.

%veriKlasoru = "C:\Users\ASUS\Desktop\matlab_project\garbage";

%% 3. Görüntü Veri Deposunun Oluşturulması
% Veri setindeki görüntüleri MATLAB ortamına aktarmak için imageDatastore yapısını kullandık.
% Alt klasörlerin tamamını dahil ettik ve klasör isimlerini otomatik etiket olarak atadık.
% Eğitim süreci tamamlandığı için bu bölüm şu an yorum satırındadır.

% goruntuVerisi = imageDatastore(veriKlasoru, ...
%     'IncludeSubfolders', true, ...
%     'LabelSource', 'foldernames');  

%% 4. Veri Seti Hakkında Temel Bilgiler
% Bu bölümde veri setindeki toplam görüntü sayısını ve mevcut sınıf etiketlerini kontrol ettik.
% Kontroller tamamlandıktan sonra kodu arşivlemek amacıyla yorum satırına aldık.

%toplamGoruntuSayisi = numel(goruntuVerisi.Files); 
%sinifIsimleri = categories(goruntuVerisi.Labels);

% disp("Toplam görüntü sayısı:");
% % disp(toplamGoruntuSayisi);
% cikti: Toplam görüntü sayısı:
%         7581
% disp("Sınıflar:");
% disp(sinifIsimleri);
% cardboard, glass, metal, paper, plastic, trash

%% 5. Veri Setinden Örnek Bir Görüntü Gösterme
% Veri setinin doğru şekilde okunduğunu doğrulamak için rastgele bir görüntü seçip görselleştirdik.
% Doğrulama tamamlandıktan sonra bu kısmı yorum satırına aldık.

% ornekIndex = randi(toplamGoruntuSayisi);
% ornekGoruntu = readimage(goruntuVerisi, ornekIndex);

% figure;
% imshow(ornekGoruntu);
% title("Etiket: " + string(goruntuVerisi.Labels(ornekIndex)));

%% 6. Eğitim ve Test Verilerinin Ayrılması
% Veri setini %70 eğitim ve %30 test olacak şekilde ayırdık.
% Model eğitimi tamamlandığı için bu adımı tekrar çalıştırmamak adına yorum satırına aldık.

% egitimOrani = 0.7;
% [egitimVerisi, testVerisi] = splitEachLabel(goruntuVerisi, egitimOrani, 'randomized');

%% 7. Eğitim ve Test Verilerinin Klasörlerden Okunması
% Alternatif bir yöntem olarak eğitim ve test verilerini ayrı klasörlerden okuduk.
% Projede bu yöntemi kullandığımız için kodu belgelemek amacıyla sakladık.

% egitimKlasoru = fullfile(veriKlasoru, "train");
% testKlasoru   = fullfile(veriKlasoru, "test");
% 
% egitimVerisi = imageDatastore(egitimKlasoru, ...
%     'IncludeSubfolders', true, ...
%     'LabelSource', 'foldernames');
% 
% testVerisi = imageDatastore(testKlasoru, ...
%     'IncludeSubfolders', true, ...
%     'LabelSource', 'foldernames');
% 
% disp("Eğitim veri sayısı:");
% disp(numel(egitimVerisi.Files));
 
% disp("Test veri sayısı:");
% disp(numel(testVerisi.Files));


%% 8. Görüntülerin Model İçin Hazırlanması
% ResNet-18 modelinin beklediği giriş boyutuna göre tüm görüntüleri yeniden boyutlandırdık.
% Eğitim verisi için veri artırma (augmentation) uyguladık.
% Eğitim tamamlandığı için bu kısım yorum satırındadır.

% girisBoyutu = [224 224 3];

% veriArtirma = imageDataAugmenter( ...
%     'RandRotation', [-10 10], ...     % Rastgele küçük döndürme
%     'RandXTranslation', [-10 10], ... % Sağa-sola kaydırma
%     'RandYTranslation', [-10 10], ... % Yukarı-aşağı kaydırma
%     'RandXReflection', true);         % Ayna alma

% egitimHazir = augmentedImageDatastore( ...
%     girisBoyutu, egitimVerisi, ...
%     'DataAugmentation', veriArtirma);
 
% Test verisi için sadece boyutlandırma
% testHazir = augmentedImageDatastore( ...
%     girisBoyutu, testVerisi);

%% 9. ResNet-18 Modelinin Düzenlenmesi
% Önceden eğitilmiş ResNet-18 modelini kullandık.
% Problemimize uygun olması için son katmanları kaldırıp yeni sınıflandırma katmanları ekledik.
% Model eğitildiği için bu bölüm arşiv amaçlıdır.

% ag = resnet18;

%% Ağın katmanları incelenir
% katmanlar = layerGraph(ag);

%% Sınıf sayısı belirlenir
% sinifSayisi = numel(categories(egitimVerisi.Labels));

%% ResNet-18'in son katmanlarını kaldırdık
% katmanlar = removeLayers(katmanlar, {'fc1000','prob','ClassificationLayer_predictions'});

%% Yeni tam bağlantılı katman ekleme
% yeniFC = fullyConnectedLayer(sinifSayisi, ...
%     'Name','yeni_fc', ...
%     'WeightLearnRateFactor',10, ...
%     'BiasLearnRateFactor',10);

%% Yeni softmax katmanı
% yeniSoftmax = softmaxLayer('Name','yeni_softmax');

%% Yeni sınıflandırma katmanı
% yeniSiniflandirma = classificationLayer('Name','yeni_siniflandirma');
 
%% Yeni katmanları ağa ekleme
% katmanlar = addLayers(katmanlar, yeniFC);
% katmanlar = addLayers(katmanlar, yeniSoftmax);
% katmanlar = addLayers(katmanlar, yeniSiniflandirma);
 
%% Katmanları birbirine bağlama
% katmanlar = connectLayers(katmanlar, 'pool5', 'yeni_fc');
% katmanlar = connectLayers(katmanlar, 'yeni_fc', 'yeni_softmax');
% katmanlar = connectLayers(katmanlar, 'yeni_softmax', 'yeni_siniflandirma');
 
% analyzeNetwork(katmanlar);

%% 10. Modelin Eğitilmesi
% Belirlediğimiz eğitim parametreleri ile modeli eğittik.
% Eğitim tamamlandıktan sonra modeli kaydedip tekrar eğitmemek için bu kodu yorum satırına aldık.

% egitimSecenekleri = trainingOptions('adam', ...
%     'MiniBatchSize', 32, ...
%      'MaxEpochs', 10, ...
%      'InitialLearnRate', 1e-4, ...
%      'Shuffle', 'every-epoch', ...
%      'ValidationData', testHazir, ...
%      'ValidationFrequency', 30, ...
%      'Verbose', true, ...
%      'Plots', 'training-progress');

% egitilmisModel = trainNetwork(egitimHazir, katmanlar, egitimSecenekleri);

%% EĞİTİM TAMAMLANDIKTAN SONRA MODEL KAYDEDİLDİ
% save("egitilmisGarbageModel.mat","egitilmisModel");

%% 11. Model Performansının Değerlendirilmesi
% Eğitilen modelin başarımını ölçmek için test verisi üzerinde tahminler yaptık.
% Accuracy ve confusion matrix sonuçlarını inceledik.
% Değerlendirme tamamlandıktan sonra bu bölüm yorum satırına alındı.

% tahminEdilenEtiketler = classify(egitilmisModel, testHazir);
% gercekEtiketler = testVerisi.Labels;
 
%% Genel doğruluk (accuracy) hesapla
% dogruluk = mean(tahminEdilenEtiketler == gercekEtiketler);

%% Yüzde cinsinden yazdır
% fprintf("Test Accuracy: %.2f %%\n", dogruluk * 100);
%% Confusion Matrix çizilir
% figure;
% confusionchart(gercekEtiketler, tahminEdilenEtiketler);
% title("Garbage Classification - Confusion Matrix");

%% 12.Confusion Matrix'in Sayısal Analizi
% Bu bölümde confusion matrix'in sayısal halini elde ettik.
% Amaç, modelin hangi sınıfları ne ölçüde doğru veya yanlış sınıflandırdığını detaylı olarak analiz etmekti.
% Analiz tamamlandıktan sonra bu kodlar tekrar çalıştırılmadığı için yorum satırı haline getirilmiştir.

% cm = confusionmat(gercekEtiketler, tahminEdilenEtiketler);

%% Sınıf Bazlı Doğruluk (Recall) Hesaplama
% Her bir sınıf için recall değerlerini hesapladık.
% Bu sayede modelin her sınıfta ne kadar başarılı olduğunu gözlemledik.

% sinifDogruluklari = diag(cm) ./ sum(cm,2);
 
% disp("Sınıf Bazlı Doğruluklar (Recall):");
% for i = 1:numel(sinifIsimleri)
%     fprintf("%s: %.2f %%\n", string(sinifIsimleri(i)), sinifDogruluklari(i)*100);
% end

%% En Çok Karışan Sınıfların Belirlenmesi
% Confusion matrix üzerinde köşegen (doğru tahminler) sıfırlanarak, modelin en fazla hata yaptığı sınıf çifti belirlendi.
% Bu analizi, modelin zayıf olduğu sınıfları tespit etmek için kullandık.

% cmHatali = cm;
% cmHatali(logical(eye(size(cmHatali)))) = 0;
% 
% [maxHata, idx] = max(cmHatali(:));
% [row, col] = ind2sub(size(cmHatali), idx);
% 
% fprintf("En çok karışan sınıflar: %s → %s (%d adet)\n", ...
%     string(sinifIsimleri(row)), string(sinifIsimleri(col)), maxHata);


