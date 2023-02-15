(in-package :grab-cl/tests)

;; NOTE: To run this test file, execute `(asdf:test-system :grab-cl)' in your Lisp.

(fiveam:def-suite grab-cl-suite)
(fiveam:in-suite grab-cl-suite)

(defun test-grab-cl-suite ()
  (fiveam:run! 'grab-cl-suite))

(defun debug-grab-cl-suite ()
  (fiveam:debug! 'grab-cl-suite))


(test operation-type-parse
  (is (string= "mutation"
           (models:content (models:content (models:last-result (funcall grab-cl/parser:parse-operation-type (prepare-string-for-parsing "mutation"))))))))

(test parse-directive
  (is (string= "directive"
               (models:content (models:last-result (funcall grab-cl/parser:parse-directive (prepare-string-for-parsing "directive")))))))

(test parse-directive-definition
  (is (equal :directive-definition
             (models:tag (first (models:result (funcall grab-cl/parser:parse-directive-definition (prepare-string-for-parsing "directive @name-here"))))))))

(test parse-type-underscore
  (let* ((type (funcall #'grab-cl/parser:parse-type-underscore (prepare-string-for-parsing "[Int]!")))
         (core-type (first (models:result type)))
         (list-type (models:content core-type))
         (sub-type (models:content list-type))
         (name-type (models:content (first sub-type))))
    (is (equal :type (models:tag core-type)))
    (is (equal :list-type (models:tag list-type)))
    (is (equal :name (models:tag name-type)))
    (is (equal 'Int (models:content name-type)))
    (is (equal :non-nullable (models:tag (second sub-type))))))

(test parse-input-value-definition
  (let* ((type (funcall grab-cl/parser:parse-input-value-definition (prepare-string-for-parsing "Name: String!"))))
    (is (equal :input-value-definition (models:tag (first (models:result type)))))))

