(defpackage grab-cl/parser
  (:use :cl :serapeum)
  (:import-from :combray/models :replace-tag :result :update-last-result :last-result :with-state)
  (:import-from :combray/combinators :pchar :pstring :pchoice :pmany :ptag :poptional :p* :p+ :psym :pmanywords :preplacetag :pnoresult :pwithsquareparens)
  (:export :parse-operation-type :parse-name :parse-directive :parse-directive-definition :parse-type-underscore :parse-input-value-definition)
  (:local-nicknames (:models :combray/models)))

(in-package :grab-cl/parser)

(defvar parse-operation-type
  (ptag
   :operation-name
   (pchoice (list
             (pstring "query")
             (pstring "mutation")
             (pstring "subscription")))))

(defvar parse-name (preplacetag :name psym))

(defvar parse-directive (pstring "directive"))

(defvar parse-directive-definition
  (ptag :directive-definition (pmanywords
                               (list (pnoresult parse-directive)
                                     (pnoresult (pchar #\@))
                                     parse-name))))
(defvar parse-non-nullable (poptional (ptag :non-nullable (pchar #\!))))

(defun parse-type-underscore (state)
  (funcall
   (ptag :type (pchoice
                (list
                 (ptag :list-type
                       (pmany (list (pwithsquareparens #'parse-type-underscore)
                                    parse-non-nullable)))
                 (pmany (list parse-name parse-non-nullable)))))
   state))

(defvar parse-input-value-definition
  (ptag :input-value-definition (pmanywords
                                 (list
                                  parse-name
                                  (pnoresult (pchar #\:))
                                  #'parse-type-underscore))))

(defvar parse-arguments-definition
  (ptag :arguments-definition
        (pwithparens (p+ parse-input-value-definition))))

(defvar parse-variable
  (ptag :variable
        (pmany (list (pnoresult (pchar #\$))
                     parse-name))))

;; (defvar parse-value
;;   (pchoice
;;    (list
;;     parse-variable
;;     )))

;; (defvar parse-default-value
;;   (ptag :default-value
;;         (pmanywords
;;          (list
;;           (pnoresult (pchar #\=) )))))

(defvar parse-variable-definition
  (ptag :variable-definition
        (pmanywords
         (list
          parse-variable
          (pnoresult (pchar #\:))
          #'parse-type-underscore))))
