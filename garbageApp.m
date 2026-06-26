function garbageApp

% GARBAGEAPP - Basit bir çöp sınıflandırma arayüzü
% Bu uygulama:
%   1. Daha önce eğitilmiş bir derin öğrenme modelini yükler.
%   2. Kullanıcının seçtiği görüntüyü veya webcam ile alınan görüntüyü sınıflandırır.
%   3. Sonucu GUI üzerinde gösterir.

% ===============================
% MODELİ YÜKLE
% ===============================
% Daha önce eğitilmiş modeli MATLAB .mat dosyasından yükle
yuklenen = load("egitilmisGarbageModel.mat");
egitilmisModel = yuklenen.egitilmisModel;

% Modelin giriş boyutu (resimlerin yeniden boyutlandırılacağı boyut)
girisBoyutu = [224 224];

% ===============================
% ARAYUZ (UI) OLUSTURMA
% ===============================
fig = uifigure('Name','Garbage Classification','Position',[100 100 700 500],'Color',[0.97 0.90 0.92]);

% Görüntü göstermek için axes
ax = uiaxes(fig,'Position',[200 150 300 300]);
title(ax,"Görüntü");
ax.Box = 'on';
ax.LineWidth = 1.5;
ax.XColor = [0.7 0.5 0.6];
ax.YColor = [0.7 0.5 0.6];
ax.Color = [1 0.97 0.98];   % çok açık pembe



% Tahmin sonucunu gösterecek label
tahminLabel = uilabel(fig,...
    'Position',[280 80 200 30],...
    'Text','Tahmin: -',...
    'FontSize',16);
tahminLabel.FontWeight = 'bold';
tahminLabel.FontColor = [0.45 0.20 0.30];

%Başlığı gösterecek label
uilabel(fig,...
    'Position',[50 460 600 35],...   % GENİŞLİK ARTIRILDI
    'Text','♻️ Akıllı Geri Dönüşüm Sınıflandırma Sistemi',...
    'FontSize',20,...
    'FontWeight','bold',...
    'HorizontalAlignment','center',...
    'FontColor',[0.4 0.15 0.25]);
% Webcam durumunu takip etmek için degisken (başlangıçta kapalı)
webcamAktif = false;
% ===============================
% GÖRÜNTÜ YÜKLE BUTONU
% ===============================

uibutton(fig,...
    'Position',[90 30 180 45],...
    'Text','📁 Görüntü Yükle',...
    'BackgroundColor',[1 0.98 0.95],...
    'FontSize',14,...
    'FontWeight','bold',...
    'ButtonPushedFcn', @(btn,event) goruntuYukle());

% Butona tıklanınca goruntuYukle fonksiyonu çalışır

% ===============================
% WEBCAM BUTONU
% ===============================
uibutton(fig,...
    'Position',[430 30 220 45],...
    'Text','📷 Webcam ile Sınıflandır',...
    'BackgroundColor',[1 0.98 0.95],...   % açık krem
    'FontSize',14,...
    'FontWeight','bold',...
    'ButtonPushedFcn', @(btn,event) webcamSiniflandir());
% Butona tıklanınca webcamSiniflandir fonksiyonu çalışır

% ===============================
% FONKSİYONLAR
% ===============================
    function goruntuYukle()   % Görüntü Yükleme Fonksiyonu
        webcamAktif = false;   % Eğer webcam açıksa durdur
        % Kullanıcıdan resim seçmesi istenir
        [dosya, yol] = uigetfile({'*.jpg;*.png'});
        if dosya == 0   % Kullanıcı iptal ettiyse çık
            return;
        end
        % Seçilen görüntüyü okur ve axes üzerinde gösterir
        img = imread(fullfile(yol,dosya));
        imshow(img,'Parent',ax);

         % Modelin beklediği boyuta getirir
        imgHazir = imresize(img, girisBoyutu);

        % Sınıflandırma yapar ve sonucu label üzerine yazar
        tahmin = classify(egitilmisModel, imgHazir);
        tahminLabel.Text = "Tahmin: " + string(tahmin);
    end

function webcamSiniflandir()   % Webcam ile Canlı Sınıflandırma
    cam = webcam;  % Varsayılan webcam'i başlat
    webcamAktif = true;   % Webcam döngüsü başladı

    try
         % Axes var olduğu ve webcamAktif true olduğu sürece döngü çalışır
        while ishandle(ax) && webcamAktif % Figure veya axes kapandığında döngü durur
            
            img = snapshot(cam); % Webcam'den görüntü al
            imshow(img,'Parent',ax);  % Axes üzerinde göster
            
             % Modelin beklediği boyuta getirir
            imgHazir = imresize(img, girisBoyutu);

             % Sınıflandırma yapar ve label üzerinde gösterir
            tahmin = classify(egitilmisModel, imgHazir);
            tahminLabel.Text = "Tahmin: " + string(tahmin);

            drawnow;  % UI güncellemesi için gerekli
        end
    catch ME
        % Hata veya webcam kapatılırsa mesaj gösterir
        disp("Webcam kapatıldı veya bir hata oluştu.");
    end
    % Döngü bittiğinde webcami temizle
    clear cam;
end
end
