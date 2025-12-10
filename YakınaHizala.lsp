(defun c:YAKINAHIZALA (/ hedefCizgi secimSeti i nesne nesneDxf mevcutNokta cizgiUzerindekiNokta yeniX yeniY eskiZ yeniNoktaListesi)
  (vl-load-com) 
  
  (prompt "\n--- KOT DEĞİsTİRMEDEN NOKTA GuNCELLEME ---")
  
  ;; 1. HEDEF cİZGİYİ SEc
  (setq hedefCizgi (car (entsel "\nReferans alinacak CIZGIYI secin: ")))
  
  (if (= hedefCizgi nil)
    (progn (alert "Hata: Bir cizgi secmediniz.") (exit))
  )

  ;; 2. NESNELERİ SEc (Nokta, Text, Blok vb.)
  (prompt "\nHizalanacak noktalari secin:")
  (setq secimSeti (ssget))

  (if secimSeti
    (progn
      (setq i 0)
      (command "_.UNDO" "_BEGIN") 
      
      (repeat (sslength secimSeti)
        (setq nesne (ssname secimSeti i))
        (setq nesneDxf (entget nesne))
        
        ;; Mevcut noktanin koordinatini al (DXF kodu 10)
        (setq mevcutNokta (cdr (assoc 10 nesneDxf))) 
        
        ;; cizgi uzerindeki 2D izdusum noktasini bul (Z göz ardi edilir)
        (setq cizgiUzerindekiNokta (vlax-curve-getClosestPointToProjection hedefCizgi mevcutNokta '(0 0 1)))
        
        (if cizgiUzerindekiNokta
          (progn
            ;; Koordinatlari ayir
            (setq yeniX (car cizgiUzerindekiNokta))  ;; cizgiden gelen X
            (setq yeniY (cadr cizgiUzerindekiNokta)) ;; cizgiden gelen Y
            (setq eskiZ (caddr mevcutNokta))         ;; Noktanin KENDİ Z'si (Asla değismez)
            
            ;; Yeni koordinat listesini olustur
            (setq yeniNoktaListesi (list 10 yeniX yeniY eskiZ))
            
            ;; Nesnenin DXF listesindeki 10 nolu kodu yenisiyle değistir
            (setq nesneDxf (subst yeniNoktaListesi (assoc 10 nesneDxf) nesneDxf))
            
            ;; Nesneyi guncelle (ENTMOD Move komutundan daha guvenlidir)
            (entmod nesneDxf)
            (entupd nesne)
          )
        )
        (setq i (1+ i))
      )
      
      (command "_.UNDO" "_END") 
      (princ (strcat "\nToplam " (itoa (sslength secimSeti)) " adet nokta sadece X-Y duzleminde tasindi. Kotlar KORUNDU."))
    )
    (princ "\nHicbir nesne secilmedi.")
  )
  (princ)
)