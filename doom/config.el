;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; ====================================
;; JOZEF KOWALSKI - Custom Config Below
;; ====================================

;; Keep file browser binding consistent between Neovim & Emacs
(map! :leader
      :desc "Dirvish"
      "f b" #'dirvish)

;; Relative line numbers
(setq display-line-numbers-type 'relative)

;; Load theme
;;(use-package base16-theme
;;  :ensure t
;;  :config
;;  (load-theme 'base16-black-metal-immortal t))
(use-package modus-themes
  :ensure t
  :demand t
  :init
  :config
  (modus-themes-load-theme 'modus-operandi))

;; Set font
(setq doom-font (font-spec :family "BerkeleyMono Nerd Font" :size 18.0))

;; Disable extremely annoying confirm to quit
(setq confirm-kill-emacs nil)

;; Enable smooth scrolling
(use-package! ultra-scroll
  :config
  (ultra-scroll-mode 1))

;; Enable Olivetti (writing plugin)
(use-package olivetti
  :ensure t
  :hook (text-mode . olivetti-mode))

;; Org-roam keybindings
(map! :leader
      :desc "Org-roam find file" "o f" #'org-roam-node-find
      :desc "Org-roam insert link" "o l" #'org-roam-node-insert
      :desc "Org-roam capture" "o c" #'org-roam-capture)

;; Enable org-roam db auto-sync
(after! org-roam
  (org-roam-db-autosync-mode))

;; Org-roam-ui config
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


;; Enable pasting via Ctrl-Shift-V (same as my Neovim keybind)
;; (map! :i "C-S-v" #'clipboard-yank)

;; Enable spell-checking
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_AU")

;; Preserve code-highlighting on export
(setq org-latex-src-block-backend 'minted)

;; Set theme for export
(setq org-latex-engraved-theme 'doom-acario-light)

;; Remove borders around links from exports (and add colours to links)
(setq org-latex-hyperref-template
    "
		\\definecolor{linkcolour}{RGB}{159, 57, 61}
		\\hypersetup{
			pdfauthor={%a},
			pdftitle={%t},
			hidelinks,
			colorlinks=true,
			linkcolor=black,
			urlcolor=linkcolour,
		}
	"
)

(setq org-latex-default-figure-position "H")

;; Setup org latex plain class
(let ((titlepage (expand-file-name "titlepage.tex" "~/.config/doom/")))
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 `("org-plain-latex"
                   ,(concat "\\documentclass{article}
				   [NO-DEFAULT-PACKAGES]
				   [PACKAGES]
				   [EXTRA]

				   % Base packages
				   \\usepackage{xcolor}
				   \\usepackage{graphicx}
				   \\usepackage{titling}
				   \\usepackage{fancyhdr}
				   \\usepackage{enumitem}
				   \\usepackage{xurl}
				   \\usepackage{float}
				   \\usepackage{booktabs}
				   \\usepackage{siunitx}
				   \\usepackage[normalem]{ulem}
				   \\usepackage{amssymb}
				   \\usepackage{titlesec}
				   \\usepackage{hyperref}
				   \\usepackage[labelformat=empty, belowskip=12pt]{caption}
				   \\usepackage[indent=24pt]{parskip}
				   \\usepackage{etoolbox}

				   \\floatplacement{listing}{H}

				   % Override \includegraphics to add a base margin around images
				   \\let\\originalincludegraphics\\includegraphics
				   \\renewcommand{\\includegraphics}[2][]{\\vspace{12pt}\\originalincludegraphics[#1]{#2}\\vspace{12pt}}

				   % Set code block style
				   \\usepackage{minted}
				   \\usepackage{mdframed}

				   \\setminted{breaklines=true, fontsize=\\small}
				   \\usemintedstyle{borland}

				   \\BeforeBeginEnvironment{mdframed}{\\vspace{10pt}}
				   \\AfterEndEnvironment{mdframed}{\\vspace{10pt}}

				   \\surroundwithmdframed[
						  backgroundcolor=gray!10,
						  linecolor=gray!40,
						  linewidth=1pt,
						  innerleftmargin=8pt,
						  innerrightmargin=8pt,
						  innertopmargin=6pt,
						  innerbottommargin=6pt,
						  roundcorner=4pt
					]{minted}

				   % Start new top-level sections on a new page
				   \\newcommand{\\sectionbreak}{\\clearpage}

				   % Replace maketitle with the titlepage.tex file, this allows us to execute commands at the last possible stage
				   % of the export process, which is useful to access file metadata more easily.
				   \\renewcommand{\\maketitle}{\\input{" titlepage "}}")

                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))

(setq org-latex-default-class "org-plain-latex")

;; Make window management behave like tmux
(define-prefix-command 'tmux-like-map)

(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "C-b") 'tmux-like-map)
  (define-key evil-normal-state-map (kbd "C-b") 'tmux-like-map))
(define-key tmux-like-map (kbd "%") 'split-window-right)
(define-key tmux-like-map (kbd "\"") 'split-window-below)
(define-key tmux-like-map (kbd "o") 'other-window)
(define-key tmux-like-map (kbd "x") 'delete-window)
(define-key tmux-like-map (kbd "<up>") 'windmove-up)
(define-key tmux-like-map (kbd "<down>") 'windmove-down)
(define-key tmux-like-map (kbd "<left>") 'windmove-left)
(define-key tmux-like-map (kbd "<right>") 'windmove-right)

;; Set Org Agenda directory
(setq org-agenda-files (directory-files-recursively "~/org-roam/" "\\.org$"))

;; Set default column view headings: Task Total-Time Time-Stamp
(setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")

;; Enable auto-formatting quotes (Electric Quotes)
(setq electric-quote-mode t)
(setq electric-quote-replace-double t)
(add-hook 'org-mode-hook 'electric-quote-local-mode)

(defun my-org-electric-quote-fix ()
  "Ensure electric-quote works with org-self-insert-command."
  (add-hook 'post-self-insert-hook #'electric-quote-post-self-insert-function 90 t))

(add-hook 'org-mode-hook #'my-org-electric-quote-fix)

;; Org Roam dailies keybinds
(map! :leader
      (:prefix ("d" . "daily notes")
       :desc "Go to today's daily note" "t" #'org-roam-dailies-goto-today))
