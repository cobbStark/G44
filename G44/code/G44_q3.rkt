#lang racket/base

;; Recursive reading:
;;   (height '())           = 0
;;   (height (v left right)) = 1 + max(height of left, height of right)
(define (height tree)
  (if (null? tree)
      0
      (+ 1 (max (height (cadr tree))
                (height (caddr tree))))))

(display (height '())) (newline)
(display (height '(1 () (2 () (3 () ()))))) (newline)