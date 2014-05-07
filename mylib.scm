;my library
(define (reverse list)
	(define (revit list res)
		(if (null?  list)
			res
			(revit (cdr list) (cons (car list) res))))
	(revit list ()))

(define (deep-reverse list)
	(define (revit list res)
		(if (null?  list)
			res
			(revit (cdr list) (cons (deep-reverse (car list)) res))))
	(if (pair? list) (revit list ()) list))

(define (for-each proc list)
	(proc (car list))
	(if (null? (cdr list)) '()
		(for-each proc (cdr list))))

(define (fringe list)
	(cond
		((null? list) list)
		 ((not (pair? list)) (cons list ()))
		(else (append (fringe (car list)) (fringe (cdr list))))))

;vectors
(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))
(define (add-vect v1 v2)
	(make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2))))
(define ( sub-vect v1 v2)
	(make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect c v)
	(make-vect (* (xcor-vect v) c) (* (ycor-vect v) c)))


(define (square x) (* x x))
(define (square-tree tree)
  (cond ((null? tree) ())
        ((not (pair? tree)) (square tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

(define (map op list)
	(if (null? list) ()
		(cons (op (car list)) (map op (cdr list)))))

(define (square-tree2 tree )
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree2 sub-tree)
             (square sub-tree)))
       tree))

(define (tree-map op tree)
 (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map op sub-tree)
             (op sub-tree)))
       tree))

(define (square-tree3 tree) (tree-map square tree))

(define (subsets s)
  (if (null? s)
      (list ())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (b) (append (list (car s)) b )) rest)))))


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (filter predicate sequence)
  (cond ((null? sequence) ())
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      ()
      (cons low (enumerate-interval (+ low 1) high))))
(define (enumerate-tree tree)
  (cond ((null? tree) ())
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))
(define (product-of-squares-of-odd-elements sequence)
  (accumulate *
              1
              (map square
                   (filter odd? sequence))))

(define (map2 p sequence)
  (accumulate (lambda (x y) (cons (p x)  y)) () sequence))
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
(define (horner-eval x coefficient-sequence)

  (accumulate (lambda (this-coeff higher-terms) (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

(define (count-leaves t)
  (accumulate +
 0 (map (lambda (x) 
	(if (pair? x) (count-leaves x) 1)) t)))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      ()
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define (map-n op . lists) 
    (define (map-n0 op  lists)
	(if (or (null? lists) (null? (car lists))) '()
	(cons (apply op (map car lists))
		(map-n0 op  (map cdr lists)))))
    (map-n0 op lists))

;(define (map-n op . seqs)
;(define (m-n op seqs)
;	(if (null? (car seqs)) ()
;		(let ((args (accumulate ;(lambda (x y) (cons (car x) y)) () seqs)) (cop(list op))) 
;			(cons (eval (append cop args))
;(m-n op (map cdr seqs))))))
;	(m-n op seqs))
			

(define (dot-product v w)
  (accumulate + 0 (map-n * v w)))
(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))
(define (transpose mat)
  (accumulate-n cons () mat))
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (fold-right op init s) (accumulate op init s))
(define nil ())

(define (reverse1 sequence)
  (fold-right (lambda (x y) (if (null? y) (cons x nil) (append y (list x)))) nil sequence))
(define (reverse2 sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

; sets

;sets
(define true #t)
(define false #f)
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (adjoin-set1 x set)
	(if (null? x) set (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)        
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2)
	(if (null? set1) set2
		(union-set (cdr set1) (adjoin-set (car set1) set2))
	)
)

(define (union-set1 set1 set2)
	(if (null? set1) set2
		(append set1 set2)))

; Classes

 ; LispMeObjects
 ; http://c2.com/cgi/wiki?LispMeObjects
 ; written by Don Wells
 ; Create a new class with (class name super '(slot value)... '(method function)).
 ; Always use 'object as the super
 ; class at the very least.
 ; a function used as a method 
 ; will take at least one argument 
 ; self, the object that originally
 ; received the method.
 ; Invoke a function by sending the 
 ; name and arguments to an
 ; object. (e.g. (send anObject 'add 'sum 10))
 ; where add is the method and sum and 10
 ; are arguments)
 ; Get the value of a slot by sending
 ; the slot's name.
 ; (e.g. (send anObject 'sum))
 ; Set the value of a slot by sending
 ; the set method defined on object.
 ; (e.g. (send anObject 'set 'sum 20))
 ; Always evaluate (clearClasses) before
 ; doing anything.

 ; an object is (superName (slotname value)... (methodName closure)...)
 ; a class is (className . object)

(define *classes* '())


 (define (clearClasses)
  (set! *classes* 
    `((object #f 
      (set ,setSlot)
      (super
         ,(lambda (self)
            (getClass (car self))))))))


 (define (setSlot self aSlotName aValue)
  (let ((slot (assoc aSlotName (cdr self))))
    (cond
      ((not slot) 
        (set-cdr! self 
          (cons 
            (list aSlotName  aValue) 
            (cdr self))))
      (else
        (set-car! (cdr slot) aValue))))
  aValue)


 (define (getClass aClass)
  (let ((class (assoc aClass *classes*)))
      (cond
        ((not class) #f)
        (else (cdr class)))))


 (define (class aName aSuperName . aDefinition)
  (set! *classes* 
    (cons 
      (cons aName (cons aSuperName aDefinition))
      *classes*))
  aName)


 (define (new aSuperName . args)
  (cons aSuperName args))


 (define (send anObject aMessage . args)
  (sendWithSelf anObject anObject aMessage args))


 (define (sendWithSelf self anObject aMessage args)
  (let 
    ((superName (car anObject))
     (slot (assoc aMessage (cdr anObject))))
    (cond
      (slot (valueOfSlot self slot args))
      ((not superName) #f)
      (else 
        (let ((superClass (getClass superName)))
          (cond
            ((not superClass) #f)
            (else
              (sendWithSelf self superClass aMessage args))))))))


 (define (valueOfSlot self theSlot args)
  (let ((value (cadr theSlot)))
    (cond
      ((procedure? value)
        (apply value (cons self args)))
      (else value))))

