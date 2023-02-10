        ; -----------------------------------------------------------------------
        ; Kullanıcıdan aldığı diziyi linkleyen uygulama
        ; -----------------------------------------------------------------------
	; Muhammed Ali LALE	20011045	Alt Seviye Programlama	Grup 1
	; -----------------------------------------------------------------------  
SSEG 	SEGMENT PARA STACK 'STACK'
	DW 32 DUP (?)
SSEG 	ENDS
        
DSEG	SEGMENT PARA 'DATA'
CR	EQU 13
LF	EQU 10
BACKSPACE DB CR, LF, '                    ',0	;consolda girdiyi backspace ile sildiğimizde sorun çıkarmaması için eklediğim bir boşluk
MENU	DB CR, LF, '   -----MENU----		                    20011045-Muhammed Ali LALE ', 0
MSG	DB CR, LF, ' 1. Dizi Olustur ', CR, LF, ' 2. Diziyi Goruntule ', CR, LF, ' 3. Yeni Eleman Ekle ', CR, LF, ' 4. CIKIS  ', 0
BLG	DB CR, LF, '  Yapmak istediginiz islemi 1-4 arasinda seciniz... ', 0
BOSLUK	DB ' ', 0
BOS	DB '    ', 0
CKS	DB CR, LF, '	cikmayi sectiniz---  ', 0
MSG1	DB CR, LF, '  Dizinin eleman sayisini giriniz: ', 0
MSG2	DB CR, LF, '  Elemanlar: ', 0
MSG3	DB CR, LF, ' Menuye gecmek icin Entera tiklayiniz : ', 0
MSG4	DB CR, LF, ' dizi:  ', 0 
MSG5	DB CR, LF, ' link:  ', 0 
MSG6	DB ' Eklemek istediginiz Elemani seciniz : ', 0
SEC	DW ?		;Menü seçimi değişkeni
N	DW 9		;Dizi boyutu
DIZI	DW 20 DUP(?)
;DIZI	DW 9,12,6,1,8,17,-2,4,3
LIST	DW 20 DUP(?)		
MIN	DW ?		;minimum değer
MINI	DW ?		;minimum değerin indisi
MAX	DW ?		;maksimum değer
MAXX	DW ?		;maksimum değer(saklanan)
MAXI	DW ?		;maksimum değerin indisi
NMAX	DW ?	
INDEX	DW ?
IND	DW ?
EK	DW ?		;eklenen eleman
LAST	DW ?		;son indis
TMP	DW ?

DSEG 	ENDS 

CSEG 	SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
ANA 	PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX, DSEG 
        MOV DS, AX
 
L0:	
	MOV AX, OFFSET MENU
        CALL PUT_STR			        ; MENU göster
	MOV AX, OFFSET MSG
        CALL PUT_STR			        ; MSG Menü seçeneklerini göster 
HATA:	MOV AX, OFFSET BLG
        CALL PUT_STR			        ; BLG’i göster
	CALL GETN 			        ; Seçimi al
        CMP AX, 1	                        ; girilen sayının 1-4 arasında olduğunu kontrol et.
        JB hata 
        CMP AX, 4
        JA hata
        MOV SEC, AX   
	CMP SEC, 4				;Seçimin 4 olup olmadığının kontrolü			
	JZ CIKIS				;Seçim 4 ise MENU döngüsünden çık	
	CMP SEC, 1				;Seçimin 1 olup olmadığının kontrolü				
	JZ S1					;Seçim 1 ise gerekli kod kesimine geç
	CMP SEC, 2				;Seçimin 2 olup olmadığının kontrolü
	JZ S2
	CMP SEC, 3				;Seçimin 3 olup olmadığının kontrolü
	JZ S3
S1:	
	CALL SEC1				;1 seçeneğin fonksiyonunu çağırma
	JMP L0
S2: 	
	CALL SEC2				;2 seçeneğin fonksiyonunu çağırma
	JMP L0
S3: 	
	CALL SEC3				;3 seçeneğin fonksiyonunu çağırma
	JMP L0					;İşlemler bittikten sonra menüyü tekrar ver
	CIKIS: MOV AX, OFFSET CKS		;looptan çıkış ve program sonu (4 seçeneği)
        CALL PUT_STR				;Çıkış Mesajı
	 RETF 
ANA 	ENDP

SEC1	PROC NEAR				;1. seçenek fonksiyonu	
	XOR SI, SI				;indis sıfırla
	MOV AX, OFFSET MSG1			;eleman sayısı isteme mesajı (dizi boyutu)
        CALL PUT_STR
	CALL GETN				;Dizi boyutunu alma
	MOV N, AX
	MOV AX, OFFSET MSG2			;Elemanları isteme

        CALL PUT_STR	
	
	MOV CX, N				
L1:	CALL GETN				;Elemanları kullanıcıdan alan döngü

	MOV DIZI[SI], AX
	ADD SI, 2
	LOOP L1
	
	MOV DX, DIZI[0]				
	MOV MIN, DX				;MIN'e dizi[0] atama
	MOV MAX, DX				;MAX'a dizi[0] atama

;--------------------------------------------------------------------
;DİZİ EKLEME VE LİNKLEME 1.AŞAMA Minimum ve maksimum değerler bulunur
;--------------------------------------------------------------------
FIND_MIN:
	XOR SI, SI				;indisi sıfırlama
	MOV CX, N
L2:	MOV AX, DIZI[SI]
	CMP AX, MIN				; Dizi[i] ? MIN karşılaştırması
	JNL END_L2				; küçük veya eşit değilse geç
	MOV MIN, AX				; küçük eşitse MIN=dizi[0]
	MOV MINI, SI				;minimum değerin indisini MINI değişkeninde saklama (eleman ekleme işlemi için)
END_L2: ADD SI, 2			
	LOOP L2
	
FIND_MAX:
	XOR SI, SI				
	MOV CX, N
L3:	MOV DX, DIZI[SI]
	CMP DX, MAX				; Dizi[i] ? MAX karşılaştırması
	JNG END_L3				; büyük veya eşit değilse geç
	MOV MAX, DX				; büyük eşitse MAX=dizi[0]
	MOV BX,SI		
END_L3: ADD SI, 2			
	LOOP L3

	MOV AX, MAX				; Sonraki işlemlerde max değeri değişeceği için 	
	MOV MAXX,AX				; dizinin en büyük değerini kalıcı MAXX değişkeninde tutuyorum

	MOV AX,-1				; en büyük elemanın linkine -1 atanır.
	MOV LIST[BX], AX
	MOV INDEX, BX				;maksimum değerin indisinden başlanarak işlem başlayacağı için indexin ilk değerine atanır
	MOV MAXI, BX				;maksimum değerin indisini MAXI değişkeninde saklama (eleman ekleme işlemi için)

;--------------------------------------------------------------------------------------------
; 2.AŞAMA en büyük elemandan başlanarak; ikinci en büyük elemanın linkine MAX  atanıp 
; bir sonrakine geçilerek linkleri minimum değere kadar yerleştirme işlemi yapılır:
;--------------------------------------------------------------------------------------------
; MIN değeri NMAX'a atanarak dizi taranır. Amaç MAXtan küçük olan en büyük değeri bulmaktır.
; Yani ikinci en büyük bulunur. MAX=NMAX olarak güncellenerek büyükten küçüğe doğru elemanlar
; belirlenir ve her birinin linkine öncekinin (büyük olanın) adresi yazılır.
;--------------------------------------------------------------------------------------------
	MOV CX, N
	DEC CX
while:	

	MOV AX, MIN				
	MOV NMAX, AX				; NMAXa MIN atanır
	XOR SI,SI
	PUSH CX					;İç döngüye girmeden CX yığına atanır
	MOV CX, N
L4:
	MOV DX, DIZI[SI]
	CMP DX, NMAX				;sırayla tüm elemanlar yeni en büyüğün (NMAX) bulunması için taranır
	JNGE END_L4
	CMP DX, MAX				;yeni en büyük MAX'tan küçük olmalı
	JNL END_L4
	MOV NMAX, DX				;NMAX'a bulunan dizi değeri atanır
	MOV AX, INDEX
	MOV LIST[SI], AX			;önceki büyük elemanın indisi bulunan NMAX'ın karşısındaki linke yerleştirilir
	MOV BX, SI
END_L4: ADD SI,2
	LOOP L4
	MOV INDEX, BX				;NMAX'ın değeri bir sonraki döngüde link olarak atanmak üzere INDEXte tutulur

	MOV AX, DIZI[BX]			;döngü sonunda bulunan NMAX MAX'a atanır. (MAX=NMAX)
	MOV MAX, AX
	POP CX					;iç döngüden çıkıldığı için CX yığından çekilir.
	LOOP while
	MOV AX, OFFSET MSG3			;Menüye dönmek için mesaj
        CALL PUT_STR			    
	CALL GETN 
	RET
SEC1	ENDP

;----------------------------------------------------------------------
;	DİZİ VE LİNKLERİ EKRANA YAZDIRMA
;----------------------------------------------------------------------

SEC2	PROC NEAR
	XOR SI,SI
	MOV CX, N
	MOV AX, OFFSET MSG4			;Diziyi yazdırma
        CALL PUT_STR
L5:		
	MOV BX, DIZI[SI]			;Diziyi yazdıran döngü
	CMP BX,10
	JNL print_dizi
	CMP BX,0				;DIZI ve LISTi yazdırırken 1 ve 2 basamaklı
	JNGE print_dizi				;sayılar arasındaki karakter farkını kapatmak (hizalamak)
	MOV AX, OFFSET BOSLUK			;için tek basamaklı elemanların başına boşluk ekledim
	CALL PUT_STR				
PRINT_DIZI:
	MOV AX, DIZI[SI]
	CALL PUTN
	MOV AX, OFFSET BOS			;Elemanlar arası boşluk
        CALL PUT_STR
	ADD SI, 2
	LOOP L5
						;---------------------------------------------------------------------------
;	XOR SI,SI				;DIZI word olarak tanımlandığı için indisler çift artıyor
;	MOV CX,N				;ödev metninde görünür indislere mi (0,1,2,3 şeklinde)
;LL:	SAR LIST[SI],1				;yoksa programdaki indislere mi (0,2,4,6) göre 
;	ADD SI,2				;yazdırma yapacağımdan emin olmadığım için ikini katları halinde yazdırdım.
;	LOOP LL					;gerekirse bu bölümde shift right, yazdırma sonunda 
						;shift left yaparak normal indisler yazdırılabilir.
						;----------------------------------------------------------------------------

	XOR SI,SI
	MOV CX, N
	MOV AX, OFFSET MSG5			;Diziyi yazdırma
        CALL PUT_STR
L6:	
	MOV BX, LIST[SI]			;Diziyi yazdıran döngü
	CMP BX,10
	JNL print_list
	CMP BX,0				;DIZI ve LISTi yazdırırken 1 ve 2 basamaklı
	JNGE print_list				;sayılar arasındaki karakter farkını kapatmak (hizalamak)
	MOV AX, OFFSET BOSLUK			;için tek basamaklı elemanların başına boşluk ekledim
	CALL PUT_STR
PRINT_LIST:	
	MOV AX, LIST[SI]
	CALL PUTN
	MOV AX, OFFSET BOS			;Elemanlar arası boşluk
        CALL PUT_STR
	ADD SI, 2
	LOOP L6
	MOV AX, OFFSET MSG3
        CALL PUT_STR			    
	CALL GETN 
	RET
SEC2	ENDP
	;----------------------------------------------------------
	; DİZİYE ELEMAN EKLEME
	;----------------------------------------------------------

SEC3	PROC NEAR				
	INC N					;Eleman eklendiği için dizinin boyutu N bir arttırılır. N++
	MOV AX, OFFSET MSG6
        CALL PUT_STR			    
	CALL GETN 				;eklenecek elemanı (EK) kullanıcıdan alma
	MOV EK, AX				
	MOV BX, N
	SHL BX,1				;SHL ile N 2 ile çarpılır. (DW sebebiyle indisler çift artıyor)
	SUB BX,2
	MOV LAST, BX				;Son elemana ulaşmak için LAST=2N-2 yapılır.
	MOV DIZI[BX],AX				;Dizinin sonuna EK atanır.
;----------------------------------------------------------
; 1. AŞAMA alınan sayı MIN ile karşılaştırılır. Küçükse 
; MINI indisi son linke atılır işlem tamamlanmış olur.
;----------------------------------------------------------	
	MOV DX, MIN
	CMP EK, DX				
	JNL cmp_max
	MOV DX, MINI
	MOV BX,LAST
	MOV LIST[BX],DX
	JMP SON
;--------------------------------------------------------------------
; 2. AŞAMA MINden küçük değilse MAXXtan büyük mü diye kontrol edilir. 
; Büyükse (yeni maksimumsa) son linke -1 değeri atanır. 
; Önceki maksimum değerinin indisindeki (MAXI) elemana 
; LAST(son eleman indisi) atanır işlem tamamlanmış olur.
;-------------------------------------------------------------------
CMP_MAX:
	MOV AX, MAXX
	CMP EK, AX
	JNG DEVAM
	MOV DI,MAXI
	MOV BX,LAST
	MOV LIST[DI],BX
	MOV AX,-1
	MOV LIST[BX],AX
	JMP SON
;-------------------------------------------------------------------------------------
; 3. AŞAMA alınan sayı MINden küçük veya MAXXtan büyük değilse 
; (ara elemansa) şu işlemler gerçekleşir:
;-------------------------------------------------------------------------------------
; 3.1. Dizi elemanları döngü içerisinde EKin daha büyük 
; olduğu bir eleman bulunana dek EK ile karşılaştırılır. 
; EKten büyük olan bulunan ilk elemanın indisi TMP değişkeninde, gösterdiği link ise 
; (bulunan elemandan bir büyük olan elemanın indisi) IND değişkeninde saklanır.
;-------------------------------------------------------------------------------------
DEVAM:
	XOR SI,SI
L7:
	MOV DX,DIZI[SI]
	CMP DX,EK
	JL END_L7
	ADD SI,2
	JMP L7
END_L7: MOV BX, LIST[SI]
	MOV IND,BX
	MOV TMP, SI
;-------------------------------------------------------------------------------
; 3.2. En son EK'ten daha küçük olan bir eleman, ve gösterdiği indisi bulmuştuk. 
; Şimdi de gösterdiği indisteki eleman ve onun da gösterdiği indis, 
; EK'ten daha büyük bir eleman bulunana denk kontrol edilir.
; İşlem sonunda TMP değişkeni EK'ten küçük en büyük sayıyı,
; IND ise EK'ten büyük en küçük sayıyı işaret eder. ([TMP] < EK < [IND])
;-------------------------------------------------------------------------------
; 3.3 Son linke IND değeri, TMP'deki linke de son eklenen sayının adresi atanır.
;-------------------------------------------------------------------------------
L8:	MOV DI,IND
	MOV DX,EK
	CMP DIZI[DI],DX
	JNL yerlestirme
	MOV SI,IND
	MOV TMP,SI
	MOV AX,LIST[SI]
	MOV IND, AX
	JMP L8
	
YERLESTIRME:
	MOV BX,LAST
	MOV AX, IND
	MOV LIST[BX],AX
	MOV DI, TMP
	MOV LIST[DI],BX
	SON:
	RET
SEC3	ENDP



GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX 	                        ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam değeri de 0’dır. 
NEW:
        CALL GETC	                        ; klavyeden ilk değeri AL’ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1	                        ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BL’ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	                ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL’deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END ANA