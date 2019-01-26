;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! add-node-modules-path)
(package! all-the-icons-dired)
(package! apib-mode)
(package! copy-as-format)
(package! dired+ :recipe (:fetcher github :repo "emacsmirror/dired-plus"))
(package! docker-compose-mode)
(package! dockerfile-mode)
(package! flycheck-apib :recipe (:fetcher github :repo "qhuyduong/flycheck-apib"))
(package! font-lock+ :recipe (:fetcher github :repo "emacsmirror/font-lock-plus"))
(package! indent-guide)
(package! lorem-ipsum)
(package! ob-async)
(package! osx-trash)
(package! prettier-js)
(package! uuidgen)

;;; Disabled packages
(package! coffee-mode :disable t)
(package! csv-mode :disable t)
(package! dhall-mode :disable t)
(package! eslintd-fix :disable t)
(package! evil-easymotion :disable t)
(package! evil-escape :disable t)
(package! evil-vimish-fold :disable t)
(package! evil-visualstar :disable t)
(package! exato :disable t)
(package! graphql-mode :disable t)
(package! skewer-mode :disable t)
(package! toml-mode :disable t)
(package! typescript-mode :disable t)
(package! vimrc-mode :disable t)
