(global-display-line-numbers-mode)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
(defun eos/org-custom-id-get (&optional pom create prefix)
  "Get the CUSTOM_ID property of the entry at point-or-marker POM.
   If POM is nil, refer to the entry at point. If the entry does
   not have an CUSTOM_ID, the function returns nil. However, when
   CREATE is non nil, create a CUSTOM_ID if none is present
   already. PREFIX will be passed through to `org-id-new'. In any
   case, the CUSTOM_ID of the entry is returned."
  (interactive)
  (org-with-point-at pom
    (let ((id (org-entry-get nil "CUSTOM_ID")))
      (cond
       ((and id (stringp id) (string-match "\\S-" id))
        id)
       (create
        (setq id (org-id-new (concat prefix "h")))
        (org-entry-put pom "CUSTOM_ID" id)
        (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
        id)))))
(defun eos/org-add-ids-to-headlines-in-file ()
  "Add CUSTOM_ID properties to all headlines in the
   current file which do not already have one."
  (interactive)
  (org-map-entries (lambda () (eos/org-custom-id-get (point) 'create))))
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   )
 )

(defun my-export-batch-function (my-org-file pos-inside-my-table my-org-table-saved-file)
  (find-file my-org-file)
  (goto-char pos-inside-my-table)
  (org-table-export my-org-table-saved-file))

(setq org-plantuml-jar-path (expand-file-name "~/.emacs.d/plantuml/plantuml.jar"))
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))

(use-package company-graphviz-dot)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(org-drill-table org-drill graphviz-dot-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'ox-beamer)
(require 'org-drill)

;; Org drill shortcuts

(require 'org-tempo)
(tempo-define-template "org-drill-1"
               '("** Item :drill:\n<QUESTION>\n\n*** Answer\n<ANSWER>")
               "<1"
               "Template for and org drill's simple topic")
(tempo-define-template "org-drill-2"
               '("** Item :drill:\n:PROPERTIES:\n:DRILL_CARD_TYPE: hide1cloze\n:END:\n\n<QUESTION>\n")
               "<2"
               "Template for an org drills' hide1cloze card")
(tempo-define-template "plant-uml-case"
               '("#+BEGIN_SRC plantuml :file <out>.png \n \n #+END_SRC")
               "<pu"
               "Template for pnalt uml")

