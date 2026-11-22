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

;; Recursive reading:
;;   (my-append '() b)         = b
;;   (my-append (x . rest) b)  = (cons x (my-append rest b))
(define (my-append a b)
  (if (null? a)
      b
      (cons (car a) (my-append (cdr a) b))))

;; Recursive reading:
;;   (inorder '())            = '()
;;   (inorder (v left right)) = (my-append (inorder left)
;;                                         (cons v (inorder right)))
(define (inorder tree)
  (if (null? tree)
      '()
      (my-append (inorder (cadr tree))
                 (cons (car tree) (inorder (caddr tree))))))

;; Recursive reading:
;;   (preorder '())            = '()
;;   (preorder (v left right)) = (cons v (my-append (preorder left)
;;                                                  (preorder right)))
(define (preorder tree)
  (if (null? tree)
      '()
      (cons (car tree)
            (my-append (preorder (cadr tree))
                       (preorder (caddr tree))))))

;; Recursive reading:
;;   (postorder '())            = '()
;;   (postorder (v left right)) = (my-append (postorder left)
;;                                           (my-append (postorder right)
;;                                                      (list v)))
(define (postorder tree)
  (if (null? tree)
      '()
      (my-append (postorder (cadr tree))
                 (my-append (postorder (caddr tree))
                            (list (car tree))))))

;; Recursive reading (not itself recursive; it delegates to inorder):
;;   (print-inorder tree) = display the list (inorder tree), then a newline.
;;   For the empty tree, (inorder '()) is '(), which display prints as ().
(define (print-inorder tree)
  (display (inorder tree))
  (newline))

;; Recursive reading (not itself recursive; it delegates to the traversals):
;;   (print-all-traversals tree) = display (inorder tree), newline,
;;                                 display (preorder tree), newline,
;;                                 display (postorder tree), newline.
;;   For the empty tree each traversal is '(), which display prints as ().
(define (print-all-traversals tree)
  (display (inorder tree))
  (newline)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))

;; Recursive reading (not itself recursive; it delegates to height and leaf-count):
;;   (print-height-and-leaves tree) = display the list (list (height tree) (leaf-count tree)),
;;                                    then a newline.
;;   For the empty tree this is (0 0).
(define (print-height-and-leaves tree)
  (display (list (height tree) (leaf-count tree)))
  (newline))

