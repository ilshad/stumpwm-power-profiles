(asdf:defsystem #:stumpwm-power-profiles
  :description "Control Power Profiles Daemon from StumpWM"
  :author "Ilshad Khabibullin <astoon.net@gmail.com>"
  :license "GPL v3"
  :version "0.0.1"
  :serial t
  :depends-on (#:stumpwm #:alexandria #:dbus)
  :components ((:file "package")
               (:file "stumpwm-power-profiles")))
