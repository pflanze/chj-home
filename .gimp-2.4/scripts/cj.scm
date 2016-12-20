;; cj von  http://www.gimp.org/tutorials/Basic_Batch/

; (define (batch-unsharp-mask pattern
; 			    radius
; 			    amount
; 			    threshold)
;   (let* ((filelist (cadr (file-glob pattern 1))))
;     (while (not (null? filelist))
;            (let* ((filename (car filelist))
;                   (image (car (gimp-file-load RUN-NONINTERACTIVE
;                                               filename filename)))
;                   (drawable (car (gimp-image-get-active-layer image))))
;              (plug-in-unsharp-mask RUN-NONINTERACTIVE
;                                    image drawable radius amount threshold)
;              (gimp-file-save RUN-NONINTERACTIVE
;                              image drawable filename filename)
;              (gimp-image-delete image))
;            (set! filelist (cdr filelist)))))

;;well bissl better oder...:

; (define (batch-unsharp-mask pattern
; 			    radius
; 			    amount
; 			    threshold)
;   (let* ((filelist (cadr (file-glob pattern 1))))
;     (for-each
;      (lambda (filename)
;        ;;(display "Hello: ") (display filename) (newline)
;        (write (list "HELLO" filename));; kommt auch nid durch so schwach he.~
;        (let* ((image (car (gimp-file-load RUN-NONINTERACTIVE
; 					  filename filename)))
; 	      (drawable (car (gimp-image-get-active-layer image)))
; 	      (outfile (string-append filename ".png")))
; 	 (plug-in-unsharp-mask RUN-NONINTERACTIVE
; 			       image drawable radius amount threshold)
; 	 (gimp-file-save RUN-NONINTERACTIVE
; 			 image
; 			 drawable
; 			 outfile
; 			 outfile)
; 	 (gimp-image-delete image)))
;      filelist)))

;; ok und nun meins?: 

(define (cj:make-batch-command cmd)
  (lambda (globpattern
	   .
	   rest)
    (let* ((filelist (cadr (file-glob globpattern 1))))
      (for-each
       (lambda (filename)
	 ;;(display "Hello: ") (display filename) (newline)
	 (write (list "HELLO" filename)) ;; kommt auch nid durch so schwach he.~
	 (let* ((image (car (gimp-file-load RUN-NONINTERACTIVE
					    filename filename)))
		(drawable (car (gimp-image-get-active-layer image)))
		(outfile (string-append filename ".png")))
	   (cmd image drawable rest)
	   (gimp-file-save RUN-NONINTERACTIVE
			   image
			   drawable
			   outfile
			   outfile)
	   (gimp-image-delete image)))
       filelist))))

(define cj:batch-unsharp-mask
  (cj:make-batch-command
   (lambda (image drawable rest)
     (apply
      plug-in-unsharp-mask
      `(,RUN-NONINTERACTIVE
	,image
	,drawable
	;; radius amount threshold:
	,@rest)))))

(define cj:batch-contrast
  (cj:make-batch-command
   (lambda (image drawable rest)
     (apply
      gimp-brightness-contrast
      `(,drawable
	;; brightness contrast   both INT32 from -127..127
	,@rest)))))

