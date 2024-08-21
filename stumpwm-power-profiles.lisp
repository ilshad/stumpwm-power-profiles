(in-package #:stumpwm-power-profiles)

(defparameter *interface* "org.freedesktop.UPower.PowerProfiles")
(defparameter *service* "org.freedesktop.UPower.PowerProfiles")
(defparameter *path* "/org/freedesktop/UPower/PowerProfiles")
(defparameter *menu-prompt* "Select profile:")

(defun get-profiles ()
  (dbus:with-open-bus (bus (dbus:system-server-addresses))
    (dbus:get-property bus *service* *path* *interface* "Profiles")))

(defun get-active-profile ()
  (dbus:with-open-bus (bus (dbus:system-server-addresses))
    (dbus:get-property bus *service* *path* *interface* "ActiveProfile")))

(defun set-active-profile (profile)
  (dbus:with-open-bus (bus (dbus:system-server-addresses))
    (dbus:invoke-method (dbus:bus-connection bus)
			"Set"
			:destination *service*
			:path *path*
			:interface "org.freedesktop.DBus.Properties"
			:signature "ssv"
			:arguments (list *interface*
					 "ActiveProfile"
					 `((:string) ,profile)))))

(defun menu-items (profiles active-profile)
  (mapcar #'(lambda (item)
	      (let ((item (second (assoc "Profile" item :test #'string=))))
		(list (format nil "~c ~a"
			      (if (string= item active-profile) #\* #\Space)
			      (string-capitalize (substitute #\Space #\- item)))
		      item)))
	  profiles))

(defun select-from-profiles-menu ()
  (let* ((active (get-active-profile))
	 (items (menu-items (get-profiles) active))
         (profile (second (select-from-menu
			   (current-screen)
			   items
			   *menu-prompt*
			   (position-if #'(lambda (x)
					    (string= (second x) active))
					items)))))
    (when (not (string= profile active))
      profile)))

(defun power-profiles-menu ()
  (when-let (profile (select-from-profiles-menu))
    (set-active-profile profile)))

(defcommand power-profiles () () (power-profiles-menu))
