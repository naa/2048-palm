;(load "mylib.scm")

(define (negate predicate)
  (lambda (x) (not (predicate x))))

(define (merge lst)
  (if (or (null? lst) (null? (cdr lst)))
      lst
      (if (= (car lst) (cadr lst))
	  (cons (* 2 (car lst)) (merge (cddr lst)))
	  (cons (car lst)  (merge (cdr lst))))))


(define (filter-zeroes lst)
  (filter (negate zero?) lst))

(define (merge-left lists)
  (map (lambda (lst)
	 (merge (filter-zeroes lst)))
       lists))

(define (list-set! list x v)
  (let ((i 0))
    (map (lambda (y) (set! i (+ i 1)) (if (= x i) v y)) list)))
  
(define (fill-up lst len)
  (do ((i 0 (+ i 1))
       (res lst (append res (list 0))))
      ((= i (- len (length lst))) res)
    ))

(define (nzeroes lists)
  (- 16
  (fold-right (lambda (y x) (+ x (length y))) 0 lists)))

(define (refill lists)
  (let ((nz (nzeroes lists)))
    (if (> nz 0)
	(let ((newp (+ 1 (random nz)))
		   (newv (if (eq? (random 10) 5) 4 2)))
	  (do ((lsts lists (cdr lsts))
	       (res ())
	       (update #t))
	      ( (null? lsts) (reverse res))
	    (set! newp (- newp (- 4 (length (car lsts)))))
	    (set! res (cons
		       (if (and update  (<= newp 0))
			   (begin
			     (set! update #f)
			     (list-set! (fill-up (car lsts) 4)
					(+ 4 newp) newv))
			   (fill-up (car lsts) 4))
		       res))))
	lists)))

(define (merge-refill lists)
	(let ((mlists (merge-left lists)))
		(if (equal? lists
			(map (lambda (x) (fill-up x 4)) mlists))
			lists
			(refill mlists))))

(define (move-left lists)
  (merge-refill lists))

(define (move-right lists)
  (map reverse (merge-refill (map reverse lists))))

(define (move-up lists)
  (transpose (merge-refill (transpose lists))))

(define (move-down lists)
  (reverse (move-up (reverse lists))))

(define (print-board lists)
  (for-each (lambda (x) (display x) (newline)) lists))

(define (print-board-to-string lists)
  (let ((outp (open-output-string)))
    (for-each (lambda (x) 
		(for-each (lambda (y)
			(display ##09 outp) 
			(display y outp)) x)
			(display ##09 outp) 
		(newline outp)) lists)
    (close-output-port outp)
    (get-output-string outp)))

(define (display-board board)
  (let ((i 1900))
    (for-each 
	(lambda (x) 
		(for-each
		    (lambda (y)
			(ctl-set-label i 
				(if (eq? 0 y) " " y))
			(set! i (+ 1 i)))
		x)) 
	board)))

(define *board* (list '(0 0 0 0) '(0 0 0 0) '(0 0 0 0) '(0 0 0 0)))

(define (new-game)
	(set! *board* (refill (merge-left (list '(0 0 0 0) '(0 0 0 0) '(0 0 0 0) '(0 0 0 0))))))
	
;(game *board*)

;(define (display-board board)
;  (fld-set-text 2001 ;(print-board-to-string board)))

(define (go)
  (own-gui #t)
  (set! *resdb*
	(dm-open-db "2048DB" 1))
  (frm-popup 2000 
 ;  (let ((*board* (list '(0 0 0 0) '(0 0 0 0) '(0 0 0 0) '(0 0 0 0))))
	(lambda (event . args)
	  (case event
	    ((frm-open)
		 (display-board *board*)
		(frm-set-focus 2001))
	    ((ctl-select)
		(case (car args)
		  ((2012)
		   (set! *board* (move-up *board*))
		   (display-board *board*))
		  ((2013)
		   (set! *board* (move-down *board*))
		   (display-board *board*))
		  ((2010)
		   (set! *board* (move-left *board*))
		   (display-board *board*))
		  ((2011)
		   (set! *board* (move-right *board*))
		   (display-board *board*))
		(else #f)))
	    ((key-down)
	        (case (car args)
		  ((##0b)
		   (set! *board* (move-up *board*))
		   (display-board *board*))
		  ((##0c)
		   (set! *board* (move-down *board*))
		   (display-board *board*))
		  (else #f)))
		((menu) 
			(case (car args) ((2100) 
			(new-game)
		   (display-board *board*))))
	    (else #f)))))

