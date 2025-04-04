
(load-theme 'leuven-dark t)

;;(set-face-attribute 'default nil :family "Adobe Utopia" :slant 'italic :weight 'normal)

(require 'package)

(setq package-archives

      '(("gnu" . "https://elpa.gnu.org/packages/")

        ("melpa" . "https://melpa.org/packages/")

        ("nongnu" . "https://elpa.nongnu.org/nongnu/"))) ;; Correct 'nongnu', not 'nognu'

(package-initialize)





(setq inhibit-startup-screen t)  ;; Disable startup screen

(menu-bar-mode -1)               ;; Hide menu bar

(tool-bar-mode -1)               ;; Hide tool bar

(scroll-bar-mode -1)             ;; Hide scroll bar



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo System Configuration (Added for Evil's undo/redo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install undo-tree package
(unless (package-installed-p 'undo-tree)
  (package-install 'undo-tree))

;; Set Evil's undo system *before* loading Evil
(setq evil-undo-system 'undo-tree)

;; Enable undo-tree globally (recommended)
(require 'undo-tree)
(global-undo-tree-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil Mode Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Download Evil

(unless (package-installed-p 'evil)

  (package-install 'evil))



;; Enable Evil

(require 'evil)

(evil-mode 1)



;; Org mode

(setq org-startup-latex-preview t)

(setq org-startup-with-inline-images t)



(set-face-attribute 'default nil

                    :family "Utopia"

                    :slant 'italic  ; 'normal, 'italic, 'oblique

                    :weight 'regular ; 'normal, 'regular, 'bold, 'light, etc.

                    :height 160 ; Optional: Set size in 1/10 points (e.g., 120 for 12pt)

                    :width 'normal ; Optional: 'condensed, 'semi-condensed, etc.

                    )





;; LSP

;; Ensure package sources like MELPA are set up



;; Install use-package if needed

(unless (package-installed-p 'use-package)

  (package-refresh-contents)

  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t) ;; Auto-install packages





(use-package corfu

  :ensure t

  :custom

  (corfu-cycle t)             ; Enable cycling for completion

  (corfu-auto t)              ; Enable auto completion

  (corfu-separator ?\s)       ; Orderless field separator

  (corfu-quit-at-boundary nil)

  (corfu-preview-current nil) ; Disable current candidate preview

  (corfu-preselect-first nil) ; Disable candidate preselection

  :init

  (global-corfu-mode)

  ;; Optional: Enable Corfu globally or hook into specific modes

  )



(use-package cape ; Completion At Point Extensions

  :ensure t

  :init

  ;; Add cape's file completion function to the standard completion-at-point-functions

  (add-to-list 'completion-at-point-functions #'cape-file)

  ;; Optionally add other backends like dabbrev, keyword, etc.

  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)

  )



;; --- LSP UI Setup (Optional Enhancements) ---

(use-package lsp-ui

  :ensure t

  :commands lsp-ui-mode

  :hook (lsp-mode . lsp-ui-mode) ; Enable lsp-ui whenever lsp-mode is active

  :config

  (setq lsp-ui-doc-enable t)

  (setq lsp-ui-doc-position 'bottom)

  (setq lsp-ui-sideline-enable t)

  )



(defun reload-init-file ()

  "Reload the Emacs init file."

  (interactive)

  (load-file user-init-file))



(global-set-key (kbd "C-c r") 'reload-init-file)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Startup Screen Configuration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; Ensure dashboard is installed

(unless (package-installed-p 'dashboard)

  (package-install 'dashboard))



;; Load and configure dashboard

(require 'dashboard)

(setq dashboard-banner-logo-title "Emacs") ; Set the title

(setq dashboard-items '((recents . 5)))     ; Configure to show only 5 recent files

(dashboard-setup-startup-hook)             ; Enable dashboard on startup



;; IMPORTANT: Disable default splash screen

(setq inhibit-startup-screen t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; History Persistence

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'savehist)

(savehist-mode 1)

(setq history-length 100) ; Optional: Save more history items



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; File Location / Session Persistence (Choose A or B, or both)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; Option A: Remember cursor position only

(require 'saveplace)

;; (setq save-place-file "~/.emacs.d/var/places") ; Optional custom location

(save-place-mode 1)



;; Option B: Remember the whole session (Often preferred)

;; (require 'desktop)

;; (desktop-save-mode 1)

;; (setq desktop-dirname "~/.emacs.d/var/desktop/") ; Optional custom location







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; End of Custom Configuration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

