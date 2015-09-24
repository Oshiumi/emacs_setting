;; ------------------------------------------------------------------------
;; @ load-path

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp"  "elpa")

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; ------------------------------------------------------------------------
;; @ general

;; common lisp
(require 'cl)

;; 文字コード
(set-language-environment "Japanese")
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (prefer-coding-system 'utf-8-unix)
         (set-default-coding-systems 'utf-8-unix)
         (setq file-name-coding-system 'sjis)
         (setq locale-coding-system 'utf-8))
        ((eq ws 'ns)
         (require 'ucs-normalize)
         (prefer-coding-system 'utf-8-hfs)
         (setq file-name-coding-system 'utf-8-hfs)
         (setq locale-coding-system 'utf-8-hfs))))

;; Windowsで英数と日本語にMeiryoを指定
;; Macで英数と日本語にRictyを指定
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (set-face-attribute 'default nil
                             :family "Meiryo"  ;; 英数
                             :height 100)
         (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Meiryo")))  ;; 日本語
        ((eq ws 'ns)
         (set-face-attribute 'default nil
                             :family "Ricty"  ;; 英数
                             :height 140)
         (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Ricty")))))  ;; 日本語


;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; ツールバー非表示
(tool-bar-mode -1)

;; メニューバーを非表示
;;(menu-bar-mode -1)

;; スクロールバー非表示
(set-scroll-bar-mode nil)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#7C756B"
                    :height 0.9)

;; 行番号フォーマット
;;(setq linum-format "%4d")

;; 括弧の強調表示
(show-paren-mode t)

;; 括弧の範囲色
;;(set-face-background 'show-paren-match-face "#")

;; 選択領域の色
(set-face-background 'region "#424536")

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables '(tab-width 4))

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;; 最近使ったファイルをメニューに表示
(recentf-mode t)

;; 最近使ったファイルの表示数
(setq recentf-max-menu-items 10)

;; 最近開いたファイルの保存数を増やす
(setq recentf-max-saved-items 3000)

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

;; バックアップを残さない
(setq make-backup-files nil)

;; 行間
(setq-default line-spacing 0)

;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

;; フレームの透明度
;;(set-frame-parameter (selected-frame) 'alpha '(0.85))
(set-background-color "#22222") ; 背景色
(set-foreground-color "#F1F7E4") ; 字の色
(set-face-foreground 'font-lock-comment-face "#5D5949") ;コメントの色
(set-face-foreground 'font-lock-string-face "#D7D75A") ;文字列の色
(set-face-foreground 'font-lock-function-name-face "#ED005E") ;関数名の色
(set-face-foreground 'font-lock-keyword-face "#F7005E") ;キーワードの色
(set-face-foreground 'font-lock-type-face "#42C8ED") ;型の色

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; ------------------------------------------------------------------------
;; tabbar
;; タブ化
;; http://www.emacswiki.org/emacs/tabbar.el
(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "<C-tab>") 'tabbar-forward)  ; 次のタブ
(global-set-key (kbd "<C-S-tab>") 'tabbar-backward) ; 前のタブ
;; タブ上でマウスホイールを使わない
(tabbar-mwheel-mode nil)
;; グループを使わない
(setq tabbar-buffer-groups-function nil)
;; 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))
;; 色設定
;;(set-face-attribute ; バー自体の色
;;   'tabbar-default nil
;;    :background "white"
;;    :family "Inconsolata"
;;    :height 1.0)
;; (set-face-attribute ; アクティブなタブ
;;   'tabbar-selected nil
;;    :background "black"
;;    :foreground "white"
;;    :weight 'bold
;;    :box nil)
;; (set-face-attribute ; 非アクティブなタブ
;;   'tabbar-unselected nil
;;    :background "white"
;;    :foreground "black"
;;    :box nil)

;;--------------------------------------------------------
;;flycheck
;;リアルタイムシンタックスチェック
(add-hook 'after-init-hook #'global-flycheck-mode)

;;-------------------------------------------------------
;;@flycheck-pos-tip
;;flycheckのエラーをその場で表示
(eval-after-load 'flycheck
  '(custom-set-variables
   '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;;------------------------------------------------------
;; Auto Complete
;;自動補完
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)

;;-----------------------------------------------------------------
;;auto-complete-c-headers
;;ヘッダの情報源
(require 'auto-complete-c-headers)
(add-hook 'c++-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))
(add-hook 'c-mode-hook '(setq ac-sources (append ac-sources '(ac-source-c-headers))))


;;-----------------------------------------------------
;;auto-complete-clang-async
(require 'auto-complete-clang-async)
(add-hook 'c++-mode-hook
          '(lambda()
             (setq ac-clang-complete-executable "~/bin/clang-complete")
             (setq ac-sources '(ac-source-clang-async))
             (ac-clang-launch-completion-process)))

