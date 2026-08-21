# IBS Uygulaması — Düzeltme ve Geliştirme Talimatı
## Mevcut Repo: github.com/Sezo88/ibs — Kod İncelemesi + Piyasa Analizi Sonucu

> **Bağlam:** Uygulama zaten kodlanmış ve çalışıyor. Bu dosya sıfırdan yazım değil, **mevcut koda uygulanacak düzeltme/geliştirme listesidir**. Agent, aşağıdaki maddeleri önce mevcut dosyalarda (`correlation_service.dart`, `tables.dart`, `meal_form_screen.dart`, `symptom_form_screen.dart`, `app_repository.dart`, `diet_plans_data.dart`) inceleyip, en az kod değişikliğiyle, geriye dönük uyumlu (mevcut kullanıcı verisini bozmadan) şekilde uygulamalıdır. Her madde önce **mevcut veriyi bozmayan bir migration** olarak düşünülmeli.

**Öncelik sırası:** P0 (yanlış/yanıltıcı sonuç riski taşıyanlar) → P1 (kullanılabilirlik) → P2 (analiz motoru derinleştirme) → P3 (piyasa paritesi / ileri seviye).

---

## P0 — Veri Doğruluğu ve Yanıltıcı Sonuç Riski

### P0.1 — Özel malzeme eklerken FODMAP/gluten/laktoz bilgisi sorulmuyor, tehlikeli varsayılan var
**Sorun:** `meal_form_screen.dart` içindeki `_addCustomIngredient`, sadece `name` alıyor. `app_repository.addIngredient` bunu `fodmapLevel: 'unknown'`, `isGluten: false`, `isLactose: false` gibi varsayılanlarla kaydediyor. Örneğin kullanıcı "Simit ekmeği" eklediğinde sistem bunu **glutensiz gibi** işaretliyor — bu, analiz sonucunu doğrudan yanlış yönlendirir.

**Düzeltme:**
- Özel malzeme ekleme formuna küçük bir adım ekle: isim girildikten sonra, kaydetmeden önce hızlı bir "etiketleme" ekranı/bottom-sheet çıksın: FODMAP seviyesi (Düşük/Orta/Yüksek/Bilmiyorum), Gluten içerir mi (Evet/Hayır/Bilmiyorum), Laktoz içerir mi (Evet/Hayır/Bilmiyorum). Varsayılan seçili değer olmasın — kullanıcı bir şey seçmeden "Bilmiyorum" ile devam edebilsin ama bu, `fodmapLevel: 'unknown'` olarak kalsın, asla sessizce `false`'a düşmesin.
- **Akıllı ön-doldurma:** İsimde "ekmek", "makarna", "un", "bulgur", "bira" gibi kelimeler geçiyorsa `isGluten` alanı otomatik "Evet" öneri olarak gelsin (kullanıcı yine değiştirebilir); "süt", "yoğurt", "peynir" geçiyorsa `isLactose` otomatik "Evet" önerilsin. Bu, kategori sözlüğü (bkz. P0.3) ile birlikte kurulmalı.

### P0.2 — Malzeme düzenleme ekranı yok
**Sorun:** Bir kere `unknown` etiketiyle eklenen malzeme sonradan düzeltilemiyor.
**Düzeltme:** Basit bir "Malzemelerim" listesi/ekranı ekle (ayarlar veya ayrı bir sekmeden erişilebilir), her malzemeye dokunarak FODMAP/gluten/laktoz/kategori alanlarını düzenleme imkanı ver.

### P0.3 — Korelasyon motoru malzemeleri tek tek değerlendiriyor, kategori/gluten grubu bazında gruplamıyor
**Sorun:** `correlation_service.dart`, her `ingredient_id`'yi ayrı ayrı analiz ediyor. 3 farklı ekmek çeşidi eklenirse hiçbiri tek başına `minOccurrenceThreshold` (3) eşiğine ulaşamayabilir ve ortak payda ("gluten") hiç görünmez.

**Düzeltme (mySymptoms'ın "a kind of" modelinden esinlenerek):**
- Yeni bir `ingredient_categories` tablosu ekle: `id, name (örn. "Gluten/Buğday", "Süt Ürünü", "Yüksek FODMAP Sebze"), parent_category_id (nullable, iç içe kategori için)`.
- `ingredients` tablosuna `category_id` (nullable) alanı ekle.
- Korelasyon hesaplamasını **iki seviyede** çalıştır: (1) mevcut tekil malzeme bazlı hesap, aynen kalsın; (2) **yeni**: aynı `category_id`'ye sahip tüm malzemelerin yenme olaylarını birleştirip kategori bazında da aynı skor/oran/güven hesabını yap. Sonuç ekranında "Tekil Malzemeler" ve "Kategoriler" olarak iki ayrı sekme/liste göster.
- Seed veride (`ingredients_seed.json`) mevcut 168 malzemeye kategori ataması yap (bu, tek seferlik bir veri-doldurma görevi, kod değişikliği değil).

### P0.4 — Korelasyon skorunda "arka plan oranı" (baseline) karşılaştırması yok
**Sorun:** Sistem sadece ham oranı (`semptomlu / toplam`) gösteriyor. Kullanıcının genel olarak sık kötü hissetme oranı yüksekse, neredeyse her yiyecek "şüpheli" çıkar.
**Düzeltme:** Kullanıcının **genel semptom oranını** (tüm zaman pencerelerinin kaçında herhangi bir semptom var, yediği şeyden bağımsız) ayrı hesapla ve bunu `baseline_rate` olarak sakla. Her malzeme için **göreli risk (lift) = malzemenin_semptom_oranı / baseline_rate** hesapla ve sonuç ekranında hem ham oranı hem lift değerini göster (örn. "Bu malzeme genel ortalamandan 2.3 kat daha riskli"). Lift ≈ 1.0 olan malzemeler "muhtemelen tesadüf" olarak işaretlenmeli.

### P0.5 — Düşük veri sayısında güven göstergesi yok
**Sorun:** 3 veriyle çıkan %33 ile 30 veriyle çıkan %33 aynı etiketi alıyor.
**Düzeltme:** mySymptoms modelini uygula — sonuç ekranında **3 ayrı metrik** göster: **Skor** (lift ile ağırlıklandırılmış birleşik skor), **Oran** (ham yüzde, mevcut haliyle kalabilir), **Güven** (veri sayısına dayalı, örn. `min(1.0, totalEaten / 10)` gibi basit bir formülle 0-1 arası bar). Güven düşükse (örn. <0.3) sonuç listesinde soluk/gri renkte gösterilsin, kesin sonuç gibi vurgulanmasın.

### P0.6 — Diyet planı içerik hatası
**Sorun:** `diet_plans_data.dart`'ta eliminasyon diyetinin 6. günü kahvaltıda "Simit + Peynir" öneriyor — simit buğday bazlı, düşük-FODMAP eliminasyon mantığıyla çelişiyor.
**Düzeltme:** O günün önerisini glutensiz bir alternatifle değiştir (örn. "Glütensiz ekmek + beyaz peynir" veya "yumurta + kabak"). Tüm diyet planı içeriğini, her önerilen malzemenin gerçekten o fazın FODMAP kısıtına uygun olup olmadığı açısından bir kez daha gözden geçir.

---

## P1 — Kullanılabilirlik (Senin Kullanırken Karşılaştığın Sürtünmeler)

### P1.1 — Öğün saatinde otomatik varsayılan yok
**Sorun:** Öğün tipi (kahvaltı/öğle/akşam) seçilince saat alanı otomatik dolmuyor.
**Düzeltme:** `meal_form_screen.dart`'ta öğün tipi seçilince `_eatenAt` alanını otomatik olarak kullanıcı ayarlarında tanımlı varsayılan saatlere göre doldur: Kahvaltı → 08:00, Öğle → 13:00, Akşam → 19:00, Atıştırma → mevcut saat (an itibarıyla). Bu varsayılan saatler **ayarlar ekranından değiştirilebilir** olsun (örn. birisi 07:00'de kahvaltı yapıyorsa). Kullanıcı yine de saate dokunup manuel değiştirebilsin — bu sadece bir ön-doldurma, kısıtlama değil.

### P1.2 — Eksik semptom tipleri: Mukus ve Acil Tuvalet İhtiyacı
**Sorun:** `symptom_form_screen.dart`'taki `_symptomTypes` listesinde bu iki klinik olarak önemli IBS semptomu yok.
**Düzeltme:** Listeye `mukus` ve `acil_tuvalet_ihtiyaci` ekle (ikon, label, renk eşlemesi dahil — mevcut 8 semptomun yapıldığı gibi). `case` switch bloklarına karşılık gelen görüntüleme metinlerini ekle: "Mukus" ve "Acil Tuvalet İhtiyacı" (Roma IV kriterlerinde "urgency" olarak geçer, IBS-D için özellikle önemli).

### P1.3 — Malzeme aramada yazım hatası toleransı yok
**Sorun:** Arama düz `LIKE '%...%'` sorgusu, "sarım" yazınca "sarımsak" çıkıyor ama "sarnisak" gibi bir yazım hatasında hiçbir şey çıkmıyor.
**Düzeltme:** Basit bir fuzzy eşleştirme ekle — örneğin sorgu sonucu boşsa, Levenshtein mesafesi ≤2 olan malzemeleri de ikincil öneri olarak göster ("Bunu mu demek istediniz: sarımsak?").

### P1.4 — Tam veri yedekleme/geri yükleme yok
**Sorun:** Sadece CSV/PDF export var (raporlama amaçlı, geri yüklenemez). Telefon değişirse veri kaybolur.
**Düzeltme:** Ayarlar ekranına "Verilerimi Yedekle" (tüm veritabanını JSON'a dök, dosya olarak paylaş/kaydet) ve "Yedekten Geri Yükle" (JSON'u okuyup veritabanına yaz — mevcut veriyle çakışırsa kullanıcıya "üzerine yaz / birleştir" seçeneği sun) özelliği ekle.

---

## P2 — Analiz Motorunu Derinleştirme (Piyasa Standardına Yaklaştırma)

### P2.1 — Gecikme dağılım grafiği (onset delay histogram)
**Neden:** Sabit bir pencere (6/24/48/72 saat) seçmek yerine, verinin kendisi hangi saat aralığında "tepe" yaptığını göstermek, kullanıcının doğru pencereyi tahmin etme yükünü kaldırır (mySymptoms'ın temel özelliği).
**Uygulama:** Seçilen malzeme + semptom çifti için, her "yeme → sonraki semptom" olayının saat farkını hesapla, bunları 6 saatlik bloklar halinde bir bar chart'ta göster (`analysis_screen.dart` içine yeni bir grafik view'i). Belirgin bir tepe noktası varsa kullanıcıya "en olası gecikme: X-Y saat" gibi bir özet metin göster.

### P2.2 — Analiz ekranında semptom tipi filtresi
**Sorun:** Şu an tüm semptom tipleri eşit ağırlıkta, `maxSeverity` bakılıyor.
**Düzeltme:** Analiz ekranına bir semptom tipi seçici ekle (örn. "Sadece: Şişkinlik, Kramp" gibi çoklu seçim), kullanıcı hangi semptomları analize dahil edeceğini seçebilsin. Varsayılan: tümü.

### P2.3 — Zaman ağırlıklandırma (recency) — opsiyonel toggle
**Düzeltme:** Ayarlarda/analiz ekranında bir "Son verilere daha çok ağırlık ver" toggle'ı ekle. Açıkken, hesaplamada son 3 aydaki olaylara 2x, daha eskilere 1x ağırlık ver (basit bir başlangıç noktası, karmaşık üstel decay şart değil).

### P2.4 — Trend grafiği (item vs semptom sıklığı, zaman içinde yan yana)
**Düzeltme:** Seçilen malzeme için, haftalık/aylık "bu malzeme kaç kez yenildi" çizgisi ile "seçili semptom kaç kez oldu" çizgisini aynı grafikte göster — iki çizginin ne kadar paralel gittiği görsel bir ipucu verir.

### P2.5 — Analiz ekranına sabit uyarı metni
**Düzeltme:** Sonuç ekranının üstüne kalıcı, kapatılamayan küçük bir not ekle: *"Bu sonuçlar korelasyondur, kesin neden-sonuç ilişkisi göstermez. Rastlantılar da yüksek skor alabilir. Kesin teşhis için doktor/diyetisyene danışın."* (mySymptoms ve tüm ciddi rakiplerde standart bir hukuki/klinik güvenlik notu.)

---

## P3 — Piyasa Paritesi / İleri Seviye (Zaman Bulunca)

| Özellik | Kısa açıklama |
|---|---|
| **Bristol Dışkı Skalası** | Bağırsak hareketi takibine 7 tipli Bristol skalası ekle — IBS-D/IBS-C ayrımı için klinik standart, `symptom_form_screen.dart`'a yeni bir alan olarak eklenebilir. |
| **Enerji / uyku kalitesi tek-slider takibi** | Confound (karıştırıcı) faktör olarak, günlük 0-10 enerji ve uyku kalitesi kaydı — analiz motoruna ileride dahil edilebilir. |
| **Semptom süresi (duration) alanı** | Semptom formuna "ne kadar sürdü" alanı — analiz için kullanılmasa da doktor raporunda değerli. |
| **3 kategorili basit sınıflandırma** | Sürekli yüzde yerine, sonuç listesinde her malzemeyi "Tetikleyici / Şüpheli / Güvenli" gibi 3 renkli rozetle özetleyen bir üst katman (Tract uygulamasının yaptığı gibi) — teknik skor aynı kalsın, sadece görselleştirme basitleşsin. |
| **Kademeli/aşamalı arayüz** | Veri az iken (örn. ilk 2 hafta) analiz ekranını basitleştir, "yeterli veri toplandıkça" daha fazla grafik/detay aç — gün 1'den karmaşık dashboard gösterme. |
| **Co-occurrence / confound ayrıştırma** | İki malzeme hep birlikte yeniyorsa (örn. ekmek+tereyağı), hangisinin gerçek suçlu olduğunu ayırt etmeye çalışan ileri seviye bir istatistik — büyük efor ister, en son sıraya bırakılabilir. |
| **Öğün tipine göre "favoriler" listesi** | Kayıt ekranında en sık kullandığın malzemeleri/yemekleri öğün tipine göre üstte göster (mySymptoms'ın hız kazandıran özelliği). |

---

## Uygulama Notları (Agent İçin)

1. **Migration disiplini:** Her yeni tablo/alan (`ingredient_categories`, `category_id`, Bristol scale alanı vb.) drift migration olarak eklensin, mevcut kullanıcı verisi kaybolmasın veya bozulmasın. Değişiklik öncesi mevcut DB'nin bir kopyasını al.
2. **Sırayla ilerle:** Önce P0'ı bitir (veri doğruluğu), sonra P1 (senin günlük kullanımını kolaylaştırır), sonra P2/P3.
3. **Her madde sonrası test et:** `flutter analyze` + varsa mevcut testler; P0.3 ve P0.4 gibi analiz motoru değişikliklerinde, değişiklik öncesi/sonrası aynı veriyle sonuçları karşılaştırıp mantıklı olduğunu doğrula.
4. **Kod inceleme skill'ini kullan:** Bu bir düzeltme/refactor görevi olduğu için `code-review` plugin'ini her P0 maddesinden sonra çalıştır — özellikle korelasyon motoru gibi kritik matematiksel kod değişikliklerinde regresyon riski yüksek.
5. **Token tasarrufu:** Bu uzun soluklu bir düzeltme oturumu olacağı için `caveman` skill'i (kurulu değilse kur) ve `/context`/`/clear` pratiğini uygula — özellikle P0→P1→P2 geçişlerinde bağlamı temizle.

---

## Agent'a Verilecek Kısa Görev Özeti (Kopyala-Yapıştır)

> "github.com/Sezo88/ibs reposundaki mevcut IBS takip uygulamasını düzeltiyoruz. Bu dosyadaki P0 maddelerini (veri doğruluğu — özellikle malzeme etiketleme varsayılanı, kategori hiyerarşisi, baseline/lift hesabı, güven göstergesi, diyet planı içerik hatası) önce uygula ve her birinden sonra `flutter analyze` + code-review çalıştır. Sonra P1 (öğün saat varsayılanı, mukus/acil tuvalet ihtiyacı semptomları, malzeme düzenleme ekranı, fuzzy arama, yedekleme) maddelerine geç. P2 ve P3'ü zaman kaldıkça uygula. Her adımda mevcut kullanıcı verisini bozmayacak migration'lar kullan, değişiklik öncesi DB yedeği al."

---

*Bu dosya, github.com/Sezo88/ibs reposundaki mevcut kod tabanına uygulanacak bir düzeltme/geliştirme planıdır; önceki mimari/veri-kaynağı dosyalarıyla birlikte kullanılmalıdır.*
