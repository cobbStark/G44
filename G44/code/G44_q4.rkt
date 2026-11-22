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
