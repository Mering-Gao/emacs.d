;;; init-locales.el --- Configure default locale -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun sanityinc/locale-var-encoding (v)
  "Return the encoding portion of the locale string V, or nil if missing."
  (when v
    (save-match-data
      (let ((case-fold-search t))
        (when (string-match "\\.\\([^.]*\\)\\'" v)
          (intern (downcase (match-string 1 v))))))))

(dolist (varname '("LC_ALL" "LANG" "LC_CTYPE"))
  (let ((encoding (sanityinc/locale-var-encoding (getenv varname))))
    (unless (memq encoding '(nil utf8 utf-8))
      (message "Warning: non-UTF8 encoding in environment variable %s may cause interop problems with this Emacs configuration." varname))))

(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))


(require-package 'spacemacs-theme)
(load-theme 'spacemacs-dark)
(require-package 'ob-mongo)
(require-package 'elpy)
(require-package 'py-autopep8)
(require-package 'pip-requirements)
(require-package 'ob-rust)
(require-package 'ob-dart)

(menu-bar-mode -1)
(global-visual-line-mode 1)
(global-display-line-numbers-mode 1)


(setq projectile-project-search-path '("~/projects/"))
(setq org-babel-check-confirm-evaluate -1)

(after-load 'python
  (elpy-enable)
  )

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (sql . t)
   (mongo . t)
   (rust . t)
   (dart . t)
   (java . t)
   (C . t)
   ))


(setq org-publish-project-alist
      '(("notes"
         :base-directory "~/projects/notes"
         :base-extension "org"
         :recursive t
         :publishing-directory "~/projects/publish/notes"
         :publishing-function org-html-publish-to-html
         :auto-sitemap t
         :makeindex t
         :sitemap-title "导航"
         :headline-levels 3
         :section-numbers t
         :with-toc t
         :html-doctype "html5"
         :html-postamble t
         :html-preamble t)
        ("pytest"
         :base-directory "~/projects/pytest"
         :base-extension "org"
         :publishing-directory "~/projects/publish/pytest"
         :publishing-function org-html-publish-to-html
         :auto-sitemap t
         :sitemap-title "导航"
         :headline-levels 3
         :sitemap-file-entry-format "%a%t%d"
         :section-numbers t
         :with-toc t
         :html-head
         :html-doctype "html5"
         :html-postamble t
         :html-preamble t
         )
        ("notes-static"
         :base-directory "~/projects/notes"
         :base-extension "jpg\\|gif\\|png\\|webp\\|js\\|jpeg"
         :publishing-directory "~/projects/publish/static"
         :publishing-function org-publish-attachment)
        ("pytest-static"
         :base-directory "~/projects/pytest"
         :base-extension "jpg\\|gif\\|png\\|webp\\|js\\|jpeg"
         :publishing-directory "~/projects/publish/static"
         :publishing-function org-publish-attachment)

        ("website" :components ("notes" "pytest" "notes-static" "pytest-static" ))))


(provide 'init-locales)
;;; init-locales.el ends here
