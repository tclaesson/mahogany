;;;; mahogany.asd

(asdf:defsystem #:mahogany
  :description "Mahogany is a tiling window manager for wayland a la stumpwm"
  :author "Stuart Dilts"
  :license  "GPL 2.0"
  :version "0.0.1"
  :depends-on (#:uiop
	       #:alexandria
	       #:cl-ansi-text
	       #:terminfo
	       #:xkbcommon
	       #:cl-wayland
	       #:snakes
	       #:iterate
	       #:cffi)
  :in-order-to ((test-op (test-op mahogany-test)))
  :pathname #p"lisp/"
  :components ((:file "log")
	       (:file "util")
	       (:file "system")
	       (:module interfaces
			:components ((:file "view-interface")))
	       (:module bindings
		        :serial t
			:depends-on ("interfaces")
			:components ((:file "package")
				     (:file "hrt-libs")
				     (:file "hrt-bindings")
				     (:file "wrappers")))
	       (:module keyboard
			:depends-on ("util")
		        :components ((:file "package")
				     (:file "keytrans")
				     (:file "key")
				     (:file "kmap")))
	       (:module tree
			:depends-on ("log" "util" "interfaces")
	       	        :components ((:file "package")
				     (:file "tree-interface")
	       			     (:file "frame" :depends-on ("tree-interface"))
				     (:file "view" :depends-on ("tree-interface"))))
	       (:file "package")
	       (:file "objects" :depends-on ("package"))
	       (:file "group" :depends-on ("objects" "bindings"))
	       (:file "state" :depends-on ("objects" "keyboard"))
	       (:file "globals" :depends-on ("state" "objects" "system"))
	       (:file "output" :depends-on ("objects" "bindings" "state"))
	       (:file "view" :depends-on ("globals" "state" "objects" "bindings"))
	       (:file "input" :depends-on ("state" "keyboard"))
	       (:file "key-bindings" :depends-on ("globals" "state" "keyboard" "tree" "input"))
	       (:file "main" :depends-on ("bindings" "keyboard" "input" "package"))))

(asdf:defsystem #:mahogany/executable
  :build-operation program-op
  :entry-point "mahogany::run-server"
  :build-pathname "build/mahogany"
  :depends-on (#:mahogany))
