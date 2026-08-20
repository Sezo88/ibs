# IBS Gıda & Semptom Takip Uygulaması
## AI Kodlama Ajanı İçin Proje Talimat Dosyası

> Bu doküman Claude Code / agent tabanlı bir geliştirme akışında kullanılmak üzere hazırlanmıştır. Mimari/planlama kararı burada verilmiştir; agent'lar kodu buna göre üretecektir.

---

## 1. Vizyon ve Problem Tanımı

**Kullanıcı:** IBS (İrritabl Bağırsak Sendromu) hastası, ne yediğinde rahatsızlandığını net olarak bilmiyor. Amaç, yenen yemek/malzeme ile sonrasında hissedilen semptomlar arasında **örüntü (pattern)** bulmak.

**Temel döngü:**
1. Kullanıcı bir öğün/yemek/malzeme kaydeder (zaman damgalı).
2. Kullanıcı belirli aralıklarla (veya semptom hissettiğinde) bir "nasıl hissediyorum" kaydı girer (şiddet, tip, zaman damgalı).
3. Uygulama, öğün ile semptom arasındaki zaman farkını hesaba katarak korelasyon çıkarır ve "şüpheli" malzemeleri/kategorileri raporlar.

**Neden bu basit görünen fikir aslında zor:** IBS'de tepki genelde **anlık değil, 2-72 saat gecikmeli** olur. Bu yüzden "bugün ne yedim → bugün nasılım" mantığı yanıltıcıdır; zaman penceresi analizi şart.

---

## 2. Uygulama Adı — Aday Listesi

Play Store'da "aranarak bulunma" (ASO) için isim, insanların gerçekten yazdığı kelimelerle örtüşmeli. Türkçe'de bu alanda arama yapan biri muhtemelen "ibs takip", "bağırsak günlüğü", "sindirim takip", "fodmap uygulama", "hassas bağırsak" gibi terimler yazar. İsim önerileri (marka + anahtar kelime dengesi gözetilerek):

| Aday | Neden işe yarar |
|---|---|
| **Bağırsak Günlüğü** | En doğrudan, "günlük/diary" formatını arayanlar için birebir eşleşir, akılda kalıcı |
| **Sindirim Günlüğüm** | "Sindirim" kelimesi IBS'i doğrudan bilmeyen ama "hazımsızlık", "mide" arayan geniş kitleyi de yakalar |
| **Tetikleyen** / **Tetikleyici Gıda** | Uygulamanın asıl vaadini (tetikleyici bulma) isimde taşır, benzersiz ve akılda kalıcı |
| **IBS Defterim** | "IBS" teşhis almış, İngilizce terimi bilen kullanıcıyı doğrudan yakalar, arama hacmi bu terimde de var |
| **Hassas Bağırsak** | "Hassas mide/bağırsak" araması yapan geniş kitleyi hedefler, IBS teşhisi olmayan ama şüphelenen kullanıcıyı da kapsar |
| **Gıda İz** / **GıdaTakip: IBS** | Kısa, marka gibi duran + anahtar kelimeli alt başlık kombinasyonu |

**Önerim:** Play Store listing'inde **kısa/marka isim + açıklayıcı alt başlık** ikilisi en iyi sonucu verir (örn. uygulama adı "Bağırsak Günlüğü", alt başlık "IBS & FODMAP Semptom Takibi"). Store listing başlığına hem "bağırsak" hem "IBS" hem "FODMAP" kelimelerinin geçmesi arama görünürlüğünü artırır. Kesin karar senin beğenine kalmış — yukarıdakilerden biri veya bir kombinasyonu marka olarak test edilebilir (ör. rakip isimlerle çakışmadığını Play Store'da kontrol et).

---

## 3. Fiyatlandırma

**Karar: Tamamen ücretsiz, reklamsız, uygulama içi satın alma yok (v1 ve öngörülebilir gelecekte).** Amaç önce kendi kullanımınla veriyi doğrulamak ve kullanıcı tabanı oluşturmak. İleride (Bölüm 13'te belirtildiği gibi) diyetisyen entegrasyonu gibi profesyonel bir katman eklenirse, o zaman premium bir kademe değerlendirilebilir — ama bu MVP'nin kapsamı dışında.

---

## 4. Piyasa Analizi (2026 itibarıyla)

| Uygulama | Güçlü yönü | Zayıf yönü / boşluk |
|---|---|---|
| **mySymptoms** | IBS topluluğunda en çok önerilen, 1-72 saat ayarlanabilir analiz penceresi, istatistiksel "şüpheli gıda" tespiti | Arayüz eski/karmaşık, elle malzeme girişi yorucu, fotoğraf yok, Türkçe/Türk mutfağı desteği yok |
| **Bowelle** | IBS'e özel, hızlı günlük tutma odaklı | Analiz derinliği sınırlı |
| **Cara Care / Nora / FODMAPLAB** | FODMAP odaklı referans veritabanı | Semptom korelasyon motoru zayıf veya yok |
| **Monash FODMAP App** | FODMAP içeriği için otorite kaynak (resmi, ücretli) | Sadece referans, günlük/korelasyon yok |
| **Fig** | Barkod okuma, sertifikalı ürün veritabanı | Paketli ürünle sınırlı, ev yemeği yok |
| **Sensio, Triggerbites (2026 yeni nesil)** | AI ile fotoğraftan/serbest metinden malzeme çıkarımı, 48-72 saatlik gecikmeli korelasyon, FODMAP/histamin/salisilat/oksalat gibi çoklu bileşik etiketleme | İngilizce/Batı mutfağı odaklı, Türkçe yok, yerel değil (bulut+abonelik) |

**Sonuç — piyasadaki asıl boşluk:**
- **Türkçe ve Türk mutfağına uygun** bir IBS takip uygulaması pratikte yok. "Mercimek çorbası", "içli köfte", "ayran" gibi yemekleri malzemesine ayırıp FODMAP/laktoz/gluten etiketleyen bir sistem yok.
- Çoğu uygulama ya *sadece referans* (Monash, FODMAPLAB) ya da *sadece günlük* (Bowelle) — ikisini birleştirip **kişiselleştirilmiş tetikleyici tespiti** yapan azdır.
- Doğal dil / hızlı giriş ("mercimek çorbası içtim, biraz sarımsaklıydı") + otomatik malzeme ayrıştırma 2026'da trend ama Türkçe'de yok.
- Eliminasyon diyeti (FODMAP fazları) rehberliğini günlük tutma ile **entegre** eden, Türkçe, ücretsiz/uygun fiyatlı bir çözüm yok.

**Senin uygulamanın farklılaşma noktası:** Türkçe-öncelikli, Türk mutfağı malzeme kütüphanesi + basit/hızlı giriş + gecikmeli korelasyon analizi + FODMAP eliminasyon rehberliği. Niş ama gerçek bir boşluk.

---

## 5. Özellik Kapsamı

### 3.1 MVP (v1 — Play Store'a çıkacak minimum sürüm)
1. **Öğün/malzeme kaydı**
   - Serbest metinle yemek adı yaz → önceden tanımlı/öğrenilen malzeme setini öner (örn. "mercimek çorbası" → soğan, mercimek, tereyağı, un — kullanıcı düzenler).
   - Malzeme bazlı ekleme (arama + otomatik tamamlama).
   - Öğün tipi (kahvaltı/öğle/akşam/atıştırma), zaman damgası (otomatik, düzenlenebilir), porsiyon (küçük/orta/büyük — opsiyonel).
   - Foto ekleme opsiyonu (sadece kayıt amaçlı, ileride AI analiz için altyapı).
2. **Semptom kaydı**
   - Hızlı giriş: 1-5 veya 1-10 şiddet skalası (kaydırma / büyük dokunma alanları — hasta hissi kötüyken karmaşık form istemez).
   - Semptom tipi (şişkinlik, kramp, ishal, kabızlık, gaz, mide bulantısı, reflü, yorgunluk — çoklu seçim).
   - Genel "iyilik hali" puanı (0-10) — günlük veya olay bazlı.
   - Zaman damgası.
3. **Zaman çizelgesi (timeline) görünümü**
   - Öğünler ve semptomlar tek bir zaman çizgisinde, renk kodlu.
4. **Temel rapor / analiz**
   - Seçilebilir zaman penceresi (0-6, 6-24, 24-48, 48-72 saat) ile "bu malzeme/kategori X kez yenildi, sonraki Y saatte semptom oranı %Z" tablosu.
   - En çok "şüpheli" ilk 5-10 malzeme/kategori listesi (basit korelasyon skoru).
   - Haftalık/aylık trend grafiği (genel iyilik hali).
5. **Malzeme kütüphanesi**
   - Yerel (offline) Türkçe temel malzeme/yemek veritabanı, FODMAP seviyesi (düşük/orta/yüksek) + laktoz/gluten/histamin bayrakları ile etiketli (bkz. Bölüm 5).
   - Barkodlu paketli ürünler için Open Food Facts API entegrasyonu (opsiyonel, internet varsa).
6. **Hatırlatıcılar**
   - "Bugün nasıl hissediyorsun?" push bildirimi (özelleştirilebilir saat/sıklık).
7. **Veri dışa aktarma**
   - PDF/CSV rapor — doktora/diyetisyene götürülebilir özet (tarih, öğün, semptom, şiddet).

### 3.2 v2 — Değer Katan Genişlemeler
- **FODMAP Eliminasyon Diyeti Modu** (Bölüm 4) — rehberli fazlar, takvim, hatırlatmalar.
- **Doğal dil girişi + basit NLP ayrıştırma**: "mercimek çorbası + bol sarımsak" yazınca malzemeleri otomatik çıkarma (başlangıçta basit anahtar kelime eşleştirme, ileride küçük bir dil modeli / embedding tabanlı eşleştirme).
- **Yemek şablonları / favoriler**: sık yenen yemekleri bir kere tanımla, sonra tek dokunuşla ekle.
- **Gelişmiş korelasyon motoru**: sadece "yenme sayısı" değil, istatistiksel anlamlılık (örn. ki-kare benzeri basit skor, mySymptoms'ın yaptığı gibi), güven aralığı gösterimi.
- **Stres/uyku/regl döngüsü gibi ek faktörler** — IBS'te bunlar da tetikleyici, opsiyonel takip alanları.
- **Dışarıda yeme modu**: restoran/paket yemek için "muhtemel içerik" tahmini + not.
- **Diyetisyen paylaşım linki**: salt-okunur özet link/QR.

### 3.3 v3 — Uzun Vadeli / Farklılaştırıcı
- Fotoğraftan malzeme tahmini (ileride küçük bir görsel model veya üçüncü parti API ile — maliyet/gizlilik dengesi kurulmalı).
- Topluluk katkılı Türk yemekleri malzeme kütüphanesi (Open Food Facts modelinde ama yemek tarifi bazlı, moderasyonlu).
- Wear OS / akıllı saat entegrasyonu ile hızlı semptom kaydı (tek dokunuş).
- Diyetisyen/doktor için ayrı web paneli (B2B fırsatı, ileride).

---

## 6. Eliminasyon Diyeti Modülü — Detay (v2, ama planı şimdiden veri modeline yansıtılmalı)

Klinik literatüre göre düşük FODMAP diyeti 3 fazdan oluşur:

1. **Eliminasyon fazı (2-6 hafta):** Tüm yüksek FODMAP gıdalar kesilir, semptomlar sakinleşene kadar sürer. 4 haftada iyileşme yoksa kullanıcı "FODMAP yanıtsızı" olabilir — uygulama bu durumda diğer nedenleri (stres, lif, vb.) araştırmaya yönlendirmeli, sonsuza dek kısıtlı diyette bırakmamalı.
2. **Yeniden giriş / meydan okuma fazı (6-8 hafta):** Her FODMAP grubu (fruktoz, laktoz, fruktanlar, GOS, poliollar/sorbitol-mannitol) ayrı ayrı, 3 gün test + 3 gün arınma (washout) şeklinde tek tek denenir. Sadece **tek bir FODMAP grubu içeren** gıdalar seçilmeli (örn. armut yerine bal/mango fruktoz testi için daha uygun, çünkü armut hem fruktoz hem poliol içerir).
3. **Kişiselleştirme / idame fazı:** Tolere edilen gruplar serbestçe geri eklenir, tolere edilmeyenler uzun vadede kısıtlanır. Amaç en az kısıtlayıcı, en sürdürülebilir diyet.

**Uygulamada karşılığı:**
- Kullanıcı "Eliminasyon Diyeti Başlat" der → takvimde faz 1 başlar, düşük-FODMAP olmayan malzemeler kayıt sırasında **uyarı** ile işaretlenir (engellenmez, sadece bilgilendirilir).
- Faz 1 sonunda "semptomların nasıldı?" özet sorusu → devam/dur kararı.
- Faz 2'de sistem otomatik olarak haftalık bir FODMAP grubu test takvimi önerir (örn. Hafta 1: laktoz, Hafta 2: fruktoz...), o hafta hangi gıdaların uygun test adayı olduğunu (tek-FODMAP-gruplu) malzeme kütüphanesinden filtreleyip önerir.
- Sonunda kullanıcıya kişisel "tolerans haritası" çıkar: hangi FODMAP grubuna duyarlı, hangisine değil.
- **Önemli sınırlama notu (uygulamada gösterilmeli):** Bu bir tıbbi tedavi değildir, diyetisyen/doktor eşliğinde yapılması önerilir. Uygulama bunu açıkça belirtmeli, teşhis koymamalı.

---

## 7. Malzeme / Gıda Veritabanı Stratejisi

Bu, projenin en kritik ve en az "hazır çözümü olan" kısmı. Araştırma sonucu bulunan kaynaklar:

- **TURKOMP (Ulusal Gıda Kompozisyon Veri Tabanı)** — TÜBİTAK-MAM'ın Tarım ve Orman Bakanlığı ile yürüttüğü resmi proje. ~645 gıda, 100 bileşen için ~63.000 veri içeriyor (turkomp.tarimorman.gov.tr). **Artısı:** resmi, güvenilir, Türkiye'de gerçekten tüketilen gıdaların isim listesi için sağlam bir temel (14 gıda grubu). **Eksisi:** bu bir *besin değeri* (enerji, vitamin, mineral) veritabanı — FODMAP, laktoz, gluten, histamin gibi IBS-özel etiketler yok, ve açık bir genel REST API'si görünmüyor (web arayüzünden aranıyor). Yani buradan **isim/kategori listesini** çekip kendi FODMAP etiketlemeni üstüne eklemen gerekir; bulk veri talebi için TÜBİTAK-MAM Gıda Enstitüsü ile iletişime geçmek (Kitap/CD olarak da satılıyor) bir seçenek.
- **Open Food Facts API** (ücretsiz, anahtar gerektirmez, ODbL lisanslı, barkod bazlı): Paketli/markalı ürünlerde iyi ama **Türk ev yemekleri ve çıplak/işlenmemiş gıdalarda (mercimek, bulgul, ev yapımı çorba) kapsamı zayıf**. Barkod tamamlayıcısı olarak değerli.
- **Hazır "yemek adı → malzeme listesi" eşleşmesi sunan resmi/açık bir Türkçe API veya veri seti bulunamadı.** Nefis Yemek Tarifleri, Yemek.com gibi siteler zengin tarif verisine sahip ama resmi API sunmuyorlar; kullanım şartları (ToS) kontrol edilmeden veri çekmek hukuki risk taşır. Bu, projenin en emek isteyen ama en güçlü farklılaşma noktası olmaya devam ediyor.

**Önerilen yaklaşım (hibrit, 3 katman):**
1. **Çekirdek malzeme sözlüğü (v1'de zorunlu):** TURKOMP'un gıda/malzeme isim listesini iskelet olarak kullan (~150-300 en sık kullanılan temel malzemeyle başla: soğan, sarımsak, mercimek, bulgur, süt, yoğurt, un, tereyağı, biber, domates vb.). Her birine elle/agent-yardımlı FODMAP seviyesi (düşük/orta/yüksek) + laktoz/gluten/histamin/kafein bayrağı ekle — kaynak olarak Monash FODMAP'ın genel kategorilerini kendi ifadenle kullan (metin kopyalama yok).
2. **Yemek şablonları (v1'de ~50-100 yaygın Türk yemeği):** Mercimek çorbası, ayran, mantı, içli köfte gibi sık yenen yemekleri, standart malzeme listeleriyle (agent'a "bu yemeğin tipik malzemeleri nedir, madde madde yaz" dedirterek) elle oluştur ve JSON'a göm. Bu, "yemek ekle" akışını gerçek kullanıcı verisiyle test edip zamanla genişlet.
3. **Open Food Facts**, barkodlu paketli ürünler için tamamlayıcı katman.

**"Sarım → sarımsak" otomatik tamamlama akışı (senin istediğin özellik, MVP'ye alınmalı):**
- Kullanıcı malzeme kutusuna yazmaya başlar → yerel SQLite'taki `ingredients` tablosunda `name_normalized LIKE 'sarım%'` (Türkçe karakter/case-insensitive normalize edilmiş) sorgusu anlık çalışır, eşleşen malzemeler dropdown'da çıkar, dokunarak seçilir.
- **Yemek adı yazınca otomatik malzeme önerisi:** Kullanıcı "mercimek çorbası" yazdığında, `meal_templates` tablosunda isim eşleşmesi (fuzzy/Levenshtein ile "mercimek çorbsı" gibi yazım hatalarını da tolere eden basit bir arama) yapılır; eşleşme bulunursa o şablonun malzeme listesi otomatik öneri olarak gösterilir, kullanıcı tek dokunuşla tümünü ekler veya tek tek çıkarır/düzenler. Eşleşme yoksa boş liste ile başlar, kullanıcı manuel ekler — **ve bu yeni girdiği kombinasyon otomatik olarak kişisel `meal_templates` tablosuna kaydedilir**, bir dahaki sefere aynı yemek adını yazınca artık öneri çıkar. Bu, zamanla yazma eforunu ciddi şekilde azaltır (kişisel sözlük büyüme mantığı).
4. **Kullanıcı katkısı / kişisel sözlük büyümesi:** Her yeni eklenen malzeme veya yemek şablonu kullanıcının kendi yerel veritabanına kaydolur. İleride (v3), moderasyonlu şekilde tüm kullanıcılar arasında paylaşılabilir hale getirilebilir (Open Food Facts'in topluluk modeline benzer, ama Türk mutfağına özel) — bu, bulut senkron (Supabase) katmanı geldiğinde anlamlı olur.

---

## 8. Mimari Karar: Yerel mi, Supabase mi?

**Tavsiye: Hibrit — "local-first" mimari, opsiyonel Supabase senkronizasyonu.**

Gerekçe:
- **Sağlık verisi hassastır.** Kullanıcı offline (internet olmadan, örn. hızlıca semptom girerken) sorunsuz çalışmalı; bulut bağımlılığı UX'i bozar ve gizlilik endişesi yaratır.
- **Play Store'a tek kullanıcılı bir "kişisel günlük" uygulaması olarak çıkacaksan**, çoğu kullanıcı tek cihaz kullanır — cihaz-içi SQLite (Flutter'da `drift` veya `sqflite`) yeterli ve hızlıdır, sunucu maliyeti sıfırdır.
- **Ama** yedekleme, cihaz değişimi, ileride "diyetisyenle paylaşım" gibi özellikler için bulut senkronizasyon değerli.

**Somut öneri:**
- **v1 (MVP):** Tamamen yerel SQLite (Flutter: `drift` paketi önerilir, tip güvenli sorgular + kolay migration). Hiç sunucu yok, tamamen offline çalışır. Bu, en hızlı Play Store çıkışını sağlar, sıfır altyapı maliyeti.
- **v1.x:** Yerel yedekleme — kullanıcının verisini şifreli bir JSON/zip olarak dışa aktarıp Google Drive'a manuel kaydetmesi (basit, sunucu gerektirmez).
- **v2:** Supabase ile **opsiyonel** bulut senkronizasyon eklenir (kullanıcı hesap açarsa). Senin zaten Supabase deneyimin var (RLS, auth) — bu noktada:
  - Her kullanıcı sadece kendi verisini görsün (RLS: `user_id = auth.uid()`), okul projesindeki RLS sıkılaştırma tecrübeni burada da uygula.
  - Supabase, senkron + çoklu cihaz + ileride "diyetisyen paylaşım linki" gibi özellikler için doğru araç.
- **Sonuç:** Yerel veritabanı **kaynak of truth (source of truth)** olarak kalsın, Supabase bir "senkron/yedek katmanı" olsun. Böylece internet olmasa da uygulama hiç bozulmaz.

---

## 9. Teknoloji Yığını Önerisi

Senin mevcut stack deneyimine (Flutter, Supabase, Capacitor) göre:

- **Flutter** — bu proje için Capacitor'dan daha uygun: yerel SQLite entegrasyonu (drift/sqflite), bildirimler (flutter_local_notifications), grafik kütüphaneleri (fl_chart / syncfusion_flutter_charts) native tarafta daha stabil ve performanslıdır. Ayrıca zaten Flutter tecrüben var (radyo uygulaması, KGM uygulaması, EKYS uygulaması).
- **Durum yönetimi:** Riverpod (EKYS projende kullandığın gibi, tutarlılık için).
- **Yerel DB:** `drift` (SQLite üzerine tip-güvenli katman, migration desteği iyi).
- **Bulut (v2):** Supabase (auth + Postgres + RLS).
- **Bildirimler:** flutter_local_notifications (yerel, sunucu gerektirmez).
- **Grafik/Rapor:** fl_chart (basit) veya syncfusion (daha zengin, lisans kontrolü gerekir).
- **PDF export:** `pdf` + `printing` paketleri.
- **Barkod okuma:** `mobile_scanner`.

---

## 10. Veri Modeli (Taslak Şema)

```
meals (öğünler)
  id, user_id, name, meal_type, eaten_at, portion_size, photo_path, notes, created_at

meal_ingredients (öğün-malzeme ilişkisi)
  id, meal_id, ingredient_id, custom_note

ingredients (malzeme kütüphanesi — yerel + kullanıcı katkılı)
  id, name, name_normalized, fodmap_level (low/medium/high),
  is_lactose, is_gluten, is_high_histamine, category, source (builtin/user/off_api), off_barcode

symptom_logs (semptom kayıtları)
  id, user_id, logged_at, overall_feeling (0-10), notes

symptom_entries (semptom detayları — bir kayıtta çoklu semptom olabilir)
  id, symptom_log_id, symptom_type (bloating/cramp/diarrhea/constipation/gas/nausea/reflux/fatigue), severity (0-10)

correlation_cache (performans için önceden hesaplanmış korelasyon sonuçları)
  id, user_id, ingredient_id, time_window_hours, occurrence_count, symptom_rate, last_calculated_at

elimination_diet_sessions (v2 — FODMAP diyet takibi)
  id, user_id, phase (elimination/reintroduction/personalization), started_at, current_fodmap_group, status

reminders
  id, user_id, time, days_of_week, enabled
```

---

## 11. Korelasyon / Analiz Mantığı (Basit Versiyon — MVP)

1. Her `symptom_log` kaydı için, geriye dönük `time_window` (kullanıcı seçebilir: 6/24/48/72 saat) içinde yenen tüm `meal_ingredients` toplanır.
2. Her malzeme için:
   - `toplam_yenme_sayısı` (o malzemenin tüm zamanlardaki yenme sayısı)
   - `semptomla_birlikte_görülme_sayısı` (yenmesinin ardından time_window içinde semptom şiddeti ≥ eşik değer olan kayıt sayısı)
   - `şüphe_skoru = semptomla_birlikte_görülme_sayısı / toplam_yenme_sayısı`
3. **Minimum veri eşiği şart**: bir malzeme en az 3-5 kez yenilmemişse "yetersiz veri" olarak işaretle, yanıltıcı sonuç gösterme (küçük örneklemde yanlış pozitif riski yüksektir — bu, mySymptoms gibi uygulamaların da dikkat ettiği bir nokta).
4. Sonuçlar basit bir tablo/liste olarak gösterilir: "Süt — 8 kez yendi, 6'sında (%75) semptom oluştu (24 saat penceresinde)."
5. **v2'de geliştirme:** İstatistiksel anlamlılık (basit ki-kare veya oran testi), FODMAP kategorisi bazında toplulaştırma (tekil malzeme yerine "yüksek FODMAP grubu" tetikliyor mu diye bakmak, çünkü tek yemekten çıkarım güçtür).

---

## 12. Gizlilik ve Yasal Notlar (Play Store için önemli)

- Bu bir **sağlık verisi** uygulaması — Play Store'da "Health" kategorisi ek politika incelemesi gerektirir (veri güvenliği formu, gizlilik politikası zorunlu).
- Uygulama içinde açıkça belirtilmeli: *"Bu uygulama tıbbi teşhis koymaz, doktor/diyetisyen tavsiyesinin yerine geçmez."*
- Yerel-öncelikli mimari zaten gizlilik açısından avantaj — bunu pazarlama metninde de öne çıkarabilirsin ("verileriniz cihazınızda kalır").
- KVKK açısından: Supabase kullanılacaksa (v2), veri işleme aydınlatma metni ve açık rıza akışı eklenmeli.

---

## 13. Yol Haritası (Öneri)

| Faz | İçerik | Tahmini kapsam |
|---|---|---|
| **Faz 0** | Proje iskeleti, yerel DB şeması, temel UI (öğün ekle, semptom ekle) | 1-2 hafta |
| **Faz 1 (MVP)** | Malzeme kütüphanesi (yerel JSON seed), timeline, basit rapor/korelasyon, bildirimler, export | 3-4 hafta |
| **Faz 2** | Open Food Facts entegrasyonu, favoriler/şablonlar, doğal dil girişi (basit) | 2-3 hafta |
| **Faz 3** | FODMAP eliminasyon diyeti modülü, gelişmiş korelasyon | 2-3 hafta |
| **Faz 4** | Supabase senkron (opsiyonel hesap), Play Store yayına hazırlık (gizlilik politikası, health data formu, store listing) | 2 hafta |
| **Faz 5+** | Fotoğraftan malzeme tahmini, topluluk veritabanı, diyetisyen paneli | Sonraki iterasyonlar |

**Play Store'a çıkış stratejisi:** Faz 1 sonunda (tam MVP) kapalı test / iç test kanalına at, kendi kullanımınla 2-4 hafta gerçek veriyle doğrula, sonra açık teste geç.

---

## 14. Claude Code Kurulumu — Kullanılacak Skill / Plugin'ler

Bu bölüm, Claude Code oturumuna projeye başlamadan önce verilecek bir kurulum talimatıdır. Agent, aşağıdaki skill/plugin'lerin kurulu olup olmadığını **önce kontrol etmeli** (`/plugin list` veya ilgili komutla), kurulu değilse kurmalıdır.

### 14.1 Zaten kullandığın, bu projede de kurulu olması gerekenler
- **`context7`** — Flutter, Riverpod, drift, Supabase gibi paketlerin güncel dokümantasyonuna erişim için şart. Bu paketler sık güncellendiğinden, agent'ın eski/hatalı API kullanmasını önler.
- **`frontend-design`** — UI ekranlarını (timeline, rapor grafikleri, öğün/semptom giriş formları) tasarlarken kullan; şablon/generic görünüm yerine özenli bir arayüz için.
- **`code-review`** — Her faz sonunda (özellikle korelasyon motoru ve DB migration kodu gibi kritik kısımlarda) otomatik kod incelemesi; hatayı erken yakalamak, sonradan "şunu düzelt" turlarıyla token harcamaktan daha ucuzdur.
- **`github`** plugin — repo, issue, PR yönetimi için.
- **`repomix`** — Codebase büyüdükçe, agent'a tüm konuşma geçmişi yerine paketlenmiş/özetlenmiş bir repo görünümü vermek için (özellikle Antigravity/Opus agent'a mimari bağlam aktarırken).
- **`obra/superpowers`** — genel iyi pratikler koleksiyonu, zaten kullandığın için bu projede de aktif kalsın.

### 14.2 Bu proje için yeni önerilen — Token Tasarrufu

- **Kurulu değilse mutlaka kur — `caveman` skill** (github.com/JuliusBrussee/caveman, skills.sh/juliusbrussee/caveman üzerinden de bulunabilir). Ne yapar: `CLAUDE.md` dosyanı otomatik olarak ~%46 daha kısa/yoğun bir forma sıkıştırır ve Claude'un çıktısını daha terse/direkt bir moda alır. Çok turlu (multi-turn) Claude Code oturumlarında (senin bu proje boyunca yapacağın gibi) prompt caching ile birleşince önemli token tasarrufu sağlıyor. Tek seferlik/izole sorularda faydası az, ama bu proje uzun soluklu bir agent akışı olacağı için tam senin kullanım şekline uygun.
- **`/context` komutunu düzenli çalıştır** — hangi skill/plugin'in ne kadar token "her oturumda otomatik" tükettiğini gösterir. Kullanmadığın plugin'leri devre dışı bırak; her yüklü skill, tetiklenmese bile sistem promptuna açıklama metni ekleyerek sabit bir token maliyeti yaratır.
- **`/clear` ve `/recap` komutlarını aktif kullan** — özellikle Faz geçişlerinde (örn. veri modeli bitip UI'a geçerken) `/clear` ile bağlamı sıfırla; oturuma dönünce `/recap` ile tüm konuşmayı tekrar oynatmadan özet al.
- **Skill sayısını 8-12 ile sınırlı tut** — çok fazla skill kurulursa her biri tetiklenmese bile sabit "context tax" öder. Ay sonunda kullanılmayan skill'leri kaldır.

### 14.3 Değerlendirilebilir (opsiyonel)
- Proje ilerledikçe Flutter/Dart'a özel bir topluluk skill'i çıkmışsa (skills.sh üzerinden ara: "flutter", "dart", "drift") kurulması faydalı olabilir — agent, kod yazmadan önce bunu kontrol etsin.
- Projenin kendine özgü tekrarlayan iş akışları netleşince (örn. "yeni malzeme ekleme + FODMAP etiketleme" rutini), Anthropic'in **Skill Creator**'ı ile kendi özel skill'ini oluşturman — her seferinde aynı kuralları yeniden anlatmak yerine, agent'ın bunu otomatik hatırlaması için — iyi bir yatırım olur.

---

## 15. AI Kodlama Ajanına Doğrudan Talimatlar

Bu bölüm, Claude Code / agent'a görev tanımı olarak verilebilir:

1. Flutter projesini `drift` + `riverpod` ile kur, klasör yapısı: `lib/data` (modeller, drift tabloları), `lib/domain` (use-case'ler, korelasyon hesaplama mantığı — saf Dart, test edilebilir), `lib/presentation` (ekranlar, widget'lar).
2. Önce **veri modelini ve drift şemasını** (Bölüm 8) kur ve migration'ları test et.
3. Korelasyon hesaplama mantığını (Bölüm 9) **ayrı, UI'dan bağımsız bir servis sınıfı** olarak yaz — birim testleri yazılabilsin.
4. Malzeme kütüphanesi seed verisini `assets/ingredients_seed.json` olarak tut, ilk açılışta DB'ye yükle.
5. Her ekran için önce basit/çirkin ama çalışan bir versiyon, sonra `frontend-design` prensipleriyle görsel iyileştirme yap (varsa ilgili skill'i kullan).
6. Bildirim, export gibi platform-bağımlı özellikleri en sona bırak; önce çekirdek CRUD + analiz akışı çalışsın.
7. Her faz sonunda `flutter analyze` ve mevcut testleri çalıştır, RLS/Supabase entegrasyonuna geçmeden önce (Faz 4) yerel akışın tamamen stabil olduğundan emin ol.
8. Supabase şemasını yazarken okul projesindeki RLS hatalarından ders çıkar: her tabloda `user_id` zorunlu, RLS policy'leri `auth.uid() = user_id` ile kısıtlanmalı, cross-user veri sızıntısına karşı test yaz.

---

## 16. Açık Kalan Kararlar (senin netleştirmen gerekenler)

- **Uygulama adı** — "GutLog" şu an yer tutucu, marka adı belirlemelisin (Play Store'da benzersiz olmalı).
- **Ücretlendirme modeli** — tamamen ücretsiz mi, freemium mı (örn. FODMAP eliminasyon modülü premium)? Rakiplerin çoğu freemium/abonelik (IBS Coach ~haftalık ücret).
- **Malzeme veritabanının ilk sürümünü kim/nasıl dolduracak** — sen elle mi curate edeceksin, yoksa bir agent'a kaynak listeler vererek mi ürettireceksin (tıbbi doğruluk kontrolü şart).
- **Diyetisyen onayı** — FODMAP modülünü yayına almadan önce bir diyetisyenle içerik doğrulaması yapmayı düşünür müsün (güven/telif/hukuki risk azaltır)?

---

*Bu dosya bir başlangıç planıdır; geliştirme sürecinde agent'lar veya sen, gerçek kullanım verisine göre revize edebilir.*
