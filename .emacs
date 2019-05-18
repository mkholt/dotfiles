;; Bind mark region, since C-SPC is bound by Samsung
(global-set-key (kbd "M-SPC") 'set-mark-command)

;; Bind M-9 to delete line
(global-set-key (kbd "M-9") 'kill-whole-line)

;; Delete the selected region when pressing the DEL key
(delete-selection-mode t)

;; Show time in mode line
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; Require the linum mode file, set the style of it and load globalized
;; Shows line numbers at the left of the buffer
(require 'linum)
(global-linum-mode 1)
;; Set the format of linum to 3 digits and a space
(setq linum-format "%3d ")

;; Highlite matching brackets
(require 'paren)
(show-paren-mode 1)

;; Show column numbers in mode line
(column-number-mode 1)

;; Split windows evenly both horizontally and vertically
(defadvice split-window-horizontally (after auto-balance activate)
  (balance-windows))

(defadvice split-window-vertically (after auto-balance activate)
  (balance-windows))

;; Hide menu and toolbars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Make sure the background mode is set before loading the theme
;; otherwise, the theme will load in light mode
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(frame-background-mode (quote dark))
 '(inhibit-startup-screen t))
