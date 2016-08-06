;; disable backup files
(setq make-backup-files nil)

;; packages
;; http://stackoverflow.com/questions/24833964/package-listed-in-melpa-but-not-found-in-package-install
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )
