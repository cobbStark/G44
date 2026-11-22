#lang racket/base

;; Recursive reading:
;;   (my-length '())         = 0
;;   (my-length (x . rest))  = 1 + (my-length rest)
;; It counts top-level elements; nested lists count as one element.
(define (my-length lst)
  (let loop ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))

;; Recursive reading:
;;   (my-map proc '())       = '()
;;   (my-map proc (x . rest)) = (cons (proc x) (my-map proc rest))
;; The named lets collect and restore results tail-recursively.
(define (my-map proc lst)
  (let collect ((remaining lst) (reversed '()))
    (if (null? remaining)
        (let restore ((items reversed) (result '()))
          (if (null? items)
              result
              (restore (cdr items) (cons (car items) result))))
        (collect (cdr remaining)
                 (cons (proc (car remaining)) reversed)))))

;; Recursive reading:
;;   (make-inserter x len-ok?) returns a function that recursively transforms
;;   a list, inserting x at the front when len-ok? accepts its original length.
(define (make-inserter x len-ok?)
  (letrec ((walk
            (lambda (lst)
              (let* ((original-length (my-length lst))
                     (walked
                      (my-map
                       (lambda (element)
                         (if (or (null? element) (pair? element))
                             (walk element)
                             element))
                       lst)))
                (if (len-ok? original-length)
                    (cons x walked)
                    walked)))))
    walk))

;; Recursive reading:
;;   insert-if-short returns (make-inserter x (lambda (length) (< length n)))
;;   so every list whose original length is less than n gets x at its front.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (length) (< length n))) lst))
