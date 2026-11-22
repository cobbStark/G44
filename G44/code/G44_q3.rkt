#lang racket/base

;; Recursive reading:
;;   (height '())           = 0
;;   (height (v left right)) = 1 + max(height of left, height of right)
(define (height tree)
  (if (null? tree)
      0
      (+ 1 (max (height (cadr tree))
                (height (caddr tree))))))


;; Recursive reading:
;;   (leaf-count '())            = 0
;;   (leaf-count (v '() '()))    = 1
;;   (leaf-count (v left right)) = (leaf-count left) + (leaf-count right)
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else (+ (leaf-count (cadr tree))
                 (leaf-count (caddr tree))))))
