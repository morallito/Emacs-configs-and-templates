;; Iago Moreira emacs config file
; V0.0.1 - 20-02-2021


; Configure Emacs to display the line numbers on the left side always
(global-display-line-numbers-mode t)

; Enable org mode 
(require 'org-id)
; Function to auto set up Id insubmodules
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


;; Org Babel languages - load languages to be used in org mode
; ATENTION - You python default sys version should have all tools needed
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   )
 )

; Org mode links in the table
(defun my-export-batch-function (my-org-file pos-inside-my-table my-org-table-saved-file)
  (find-file my-org-file)
  (goto-char pos-inside-my-table)
  (org-table-export my-org-table-saved-file))
