(defsystem #:grab-cl
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:serapeum :combray)
  :serial T
  :components ((:module "src"
                :components
                ((:file "parser"))))
  :description ""
  :in-order-to ((test-op (test-op "grab-cl/tests"))))

(defsystem #:grab-cl/tests
  :author ""
  :license ""
  :depends-on ("grab-cl"
               "fiveam")
  :serial T
  :components ((:module "tests"
                :components
                ((:file "package")
                 (:file "main"))))
  :description "Test system for grab-cl"
  :perform (test-op (op s) (symbol-call :grab-cl/tests '#:debug-grab-cl-suite)))
