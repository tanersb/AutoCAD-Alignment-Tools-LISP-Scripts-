(defun c:OTOHIZALA (/ secimSeti i nesne nesneDxf noktaListesi x y n sumX sumY sumXY sumX2 egim m kesim b minX maxX p1 p2 yeniCizgi)
  (vl-load-com)

  (prompt "\n--- OTOMATİK ORTALAMA cİZGİ OLUsTUR VE HİZALA ---")
  
  ;; 1. NOKTALARI SEc
  (prompt "\nOrtalama cizgisi olusturulacak noktalari secin:")
  (setq secimSeti (ssget))
  
  (if (not secimSeti)
    (progn (princ "\nNesne secilmedi.") (exit))
  )

  ;; 2. VERİLERİ TOPLA
  (setq noktaListesi '())
  (setq i 0)
  
  (repeat (sslength secimSeti)
    (setq nesne (ssname secimSeti i))
    (setq nesneDxf (entget nesne))
    (setq p (cdr (assoc 10 nesneDxf))) ; Noktanin koordinati
    
    ;; Nokta koordinatlarini listeye ekle
    (setq noktaListesi (cons p noktaListesi))
    (setq i (1+ i))
  )

  ;; 3. DOĞRUSAL REGRESYON (EN KÜcÜK KARELER YÖNTEMİ) HESAPLA
  (setq n (length noktaListesi))
  (setq sumX 0.0 sumY 0.0 sumXY 0.0 sumX2 0.0)
  (setq minX (car (car noktaListesi)))
  (setq maxX (car (car noktaListesi)))

  (foreach p noktaListesi
    (setq x (car p))
    (setq y (cadr p))
    
    (setq sumX (+ sumX x))
    (setq sumY (+ sumY y))
    (setq sumXY (+ sumXY (* x y)))
    (setq sumX2 (+ sumX2 (* x x)))
    
    ;; cizginin uzunluğunu belirlemek icin en kücük ve en büyük X'i bul
    (if (< x minX) (setq minX x))
    (if (> x maxX) (setq maxX x))
  )

  ;; Regresyon Formülleri
  ;; Eğim (m) = (n*SumXY - SumX*SumY) / (n*SumX2 - SumX^2)
  (setq pay (- (* n sumXY) (* sumX sumY)))
  (setq payda (- (* n sumX2) (* sumX sumX)))

  (if (equal payda 0.0 0.0001)
    (progn
      (alert "Hata: Noktalar dikey olarak hizalanmis, ortalama X kullaniliyor.")
      ;; Dikey cizgi durumu (Slope infinity)
      (setq m nil) 
      (setq b (/ sumX n)) ; b burada X değerini tutar
    )
    (progn
      ;; Normal eğimli cizgi
      (setq m (/ pay payda))
      ;; Kesim Noktasi (b) = (SumY - m*SumX) / n
      (setq b (/ (- sumY (* m sumX)) n))
    )
  )

  ;; 4. ORTALAMA cİZGİYİ cİZ
  (if m
    (progn
      ;; Y = mx + b formülüne göre baslangic ve bitis noktalari
      (setq p1 (list minX (+ (* m minX) b) 0.0))
      (setq p2 (list maxX (+ (* m maxX) b) 0.0))
    )
    (progn
      ;; Dikey cizgi durumu
      (setq minY (cadr (car noktaListesi)))
      (setq maxY (cadr (car noktaListesi)))
      (foreach p noktaListesi
        (if (< (cadr p) minY) (setq minY (cadr p)))
        (if (> (cadr p) maxY) (setq maxY (cadr p)))
      )
      (setq p1 (list b minY 0.0))
      (setq p2 (list b maxY 0.0))
    )
  )

  ;; cizgiyi olustur (Rengi Kirmizi - Color 1)
  (entmake (list (cons 0 "LINE") (cons 10 p1) (cons 11 p2) (cons 62 1)))
  (setq yeniCizgi (entlast))
  
  (prompt "\nOrtalama cizgi (Kirmizi) olusturuldu. simdi noktalar hizalaniyor...")

  ;; 5. NOKTALARI BU YENİ cİZGİYE HİZALA (Z KORUYARAK - Önceki kodun aynisi)
  (command "_.UNDO" "_BEGIN")
  (setq i 0)
  
  (repeat (sslength secimSeti)
    (setq nesne (ssname secimSeti i))
    (setq nesneDxf (entget nesne))
    (setq mevcutNokta (cdr (assoc 10 nesneDxf)))
    
    ;; 2D izdüsüm (Z'yi göz ardi et)
    (setq cizgiUzerindekiNokta (vlax-curve-getClosestPointToProjection yeniCizgi mevcutNokta '(0 0 1)))
    
    (if cizgiUzerindekiNokta
      (progn
        (setq yeniX (car cizgiUzerindekiNokta))
        (setq yeniY (cadr cizgiUzerindekiNokta))
        (setq eskiZ (caddr mevcutNokta)) ;; KOT KORUNUYOR
        
        ;; Koordinati güncelle
        (setq yeniNoktaListesi (list 10 yeniX yeniY eskiZ))
        (setq nesneDxf (subst yeniNoktaListesi (assoc 10 nesneDxf) nesneDxf))
        (entmod nesneDxf)
        (entupd nesne)
      )
    )
    (setq i (1+ i))
  )
  
  (command "_.UNDO" "_END")
  (princ "\nİslem Tamamlandi.")
  (princ)
)