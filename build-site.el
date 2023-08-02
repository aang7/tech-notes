;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'org)
(require 'ox-publish)
(require 'htmlize)
(require 'ox-html)

(defvar aang-date-format "%b %d, %Y")
(setq org-confirm-babel-evaluate nil)
;; setting to nil, avoids "Author: x" at the bottom
(setq org-export-with-section-numbers nil
      org-export-with-smart-quotes t
      org-export-with-toc nil)

;; Customize the HTML output
(setq org-html-validation-link t            ;; Don't show validation link
      org-html-head-include-scripts t       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      ;;org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
      )


(setq org-html-divs '((postamble "footer" "postamble"))
      org-html-container-element "section"
      org-html-metadata-timestamp-format aang-date-format
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link t
      org-html-doctype "html5"
      org-html-htmlize-output-type 'css
      org-src-fontify-natively t)

(defvar aang-website-html-postamble
  "
<div class='footer'>
Copyright © 2022 <a href='mailto:aang.drummer@gmail.com'>Abel Güitian</a> | <a href='https://github.com/aang7/aang7.github.io'>Source</a><br>
Last updated on %C using %c <br>
</div>")


(defun aang-website-html-preamble (plist)
  "PLIST: An entry."
  ;; Skip adding subtitle to the post if :KEYWORDS don't have 'post' has a
  ;; keyword
  ;; (when (string-match-p "post" (format "%s" (plist-get plist :keywords)))
  ;;   (plist-put plist
  ;; 	       :subtitle (format "Published on %s by %s."
  ;; 				 (org-export-get-date plist aang-date-format)
  ;; 				 (car (plist-get plist :author)))))

  ;; Below content will be added anyways
  "")

(defvar aang-website-html-head
  "<link rel='stylesheet' href='https://cdn.simplecss.org/simple.min.css' />
   <link rel='stylesheet' type='text/css' href='../css/tech-notes-site.css' />")



(defun aang/org-sitemap-format-entry (entry style project)
  "Format posts with author and published data in the index page.

ENTRY: file-name
STYLE:
PROJECT: `posts in this case."
  (cond ((not (directory-name-p entry))
         (format "*[[file:%s][%s]]*
                 #+HTML: <p class='pubdate'>by %s on %s.</p>"
                 entry
                 (org-publish-find-title entry project)
                 (car (org-publish-find-property entry :author project))
                 (format-time-string aang-date-format
                                     (org-publish-find-date entry project))))
        ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
        (t entry)))


;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./notes"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil            ;; Don't include author name
             :with-creator nil           ;; Include Emacs and Org versions in footer
             :with-toc nil               ;; Include a table of contents
             :section-numbers nil        ;; Don't include section numbers
             :time-stamp-file nil	 ;; Don't include time stamp in file
	     :html-postamble aang-website-html-postamble
	     :html-preamble 'aang-website-html-preamble
	     :html-head aang-website-html-head
	     :auto-sitemap nil
	     :sitemap-filename "index.org"
	     :sitemap-title "Abel's notes"
	     :sitemap-format-entry 'aang/org-sitemap-format-entry
	     :html-link-home "../"
             :html-link-up "../"
	     ;;:sitemap-style 'list
	     )
       (list "css"
	 :base-directory "css/"
	 :base-extension "css"
	 :publishing-directory "./public/css"
	 :publishing-function 'org-publish-attachment
	 :recursive t)
       (list "static-files"
	 :base-directory "./notes"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|jpeg"
	 :publishing-directory "./public"
	 :recursive t
	 :publishing-function 'org-publish-attachment
	 )
       ))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
