;; Mac用の設定
;; CommandとOptionを入れ替える
(setq ns-command-modifier (quote meta))
(setq ns-allternate-modifier (quote super))

;; rbenvのパスを通すためにいろいろと記述(必要なさそうなのはコメントアウト)
;; より下に記述した物が PATH の先頭に追加されます
(dolist (dir (list
              ;; "/sbin"
              ;; "/usr/sbin"
              ;; "/bin"
              "/usr/bin"                ;ruby(default)
              ;; "/opt/local/bin"
              ;; "/sw/bin"
              "/usr/local/bin"          ;rbenv
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
 ;; PATH と exec-path に同じ物を追加します
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

;; rbenvでインストールしたrubyのバージョンを通すために
(setenv "PATH" (concat (expand-file-name "~/.rbenv/shims:") (getenv "PATH")))


;; パッケージを追加
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
          (expand-file-name (concat user-emacs-directory path))))
    (add-to-list 'load-path default-directory)
    (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
        (normal-top-level-add-subdirs-to-load-path))))))
;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elpa" "elisp")


;; 起動時のフレーム、モードライン(マシンによって変えるため、TOPに持ってくる)
(setq default-frame-alist
      (append
       (list
    '(foreground-color . "peach puff") ;文字の色
    '(background-color . "#2F4F4F")    ;背景色
    '(top . 0)                         ;フレーム左上位置 Y座標
    '(left . 0)                        ;フレーム左上位置 X座標
    '(width . 175)                     ;フレーム幅(文字数)
    '(height . 50)                     ;フレーム高さ(文字数)
    '(vertical-scroll-bars . right)    ;スクロールバーの左/右/非表示(left[defaul]/right/nil)
    '(cursor-color . "white")          ;カーソルの色(box/barの場合に設定可)
    )
       default-frame-alist))

;; 日本語環境
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
;; (prefer-coding-system 'shift_jis)

;; Windows IME
;; (setq default-input-method "MW32-IME")

;; ファイルの種類ごとに優先文字コードを設定する
(modify-coding-system-alist 'file "\\.rb\\'" 'utf-8) ;ruby

;; 拡張子でメジャーモード指定
(add-to-list 'auto-mode-alist '("\\.cgi\\'" . perl-mode)) ;cgiをperl-modeで

;; Anythingの設定(重要なのでTOPの方で読み込み)
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)
  (when (require 'anything-config nil t)
    (setq anything-su-or-sudo "sudo"))
  (require 'anything-match-plugin nil t)
  (when (and (executable-find "cmigemo")
         (require 'migemo nil t))
    (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))
  (require 'anything-show-completion nil t)
  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))
  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install)))

;; シェルコマンド履歴から補完
;; (require 'anything-startup)
;; (anything-complete-shell-history-setup-key (kbd "C-o"))

;; 過去のkill-ringの内容を取り出す
(require 'anything-startup)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;; M-yで候補が出る

;; 警告音、フラッシュ全て無効
(setq ring-bell-function 'ignore)

;; キーボード同時押しのキーバインドを可能にする
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)

;; キーバインド
(define-key global-map (kbd "C-c C-l") 'toggle-truncate-lines)   ;文字折り返しをトグル的に
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)     ;文字折り返しをトグル的に(org-modeのためにこちらも用意)
(define-key global-map (kbd "C-c j") 'goto-line)                 ;行番号ジャンプ
(define-key global-map (kbd "C-c o") 'occur)                     ;Occurバッファに検索結果表示(e:編集 C-c C-c:編集終了)
(define-key global-map (kbd "C-M-g") 'grep)                      ;grep
(define-key global-map (kbd "C-c g f") 'grep-find)               ;grep-find(サブディレクトリも)
(define-key global-map (kbd "C-¥") 'redo)                        ;redo(macで¥はoptionと一緒に)
(define-key global-map (kbd "C-c m d") 'shell)                   ;shell
(define-key global-map (kbd "C-c e") 'eshell)                    ;eshell
(define-key global-map (kbd "C-c b r") 'rename-buffer)           ;rename-buffer
(define-key global-map (kbd "C-.") 'just-one-space)              ;空白をひとつにまとめる
(define-key global-map (kbd "C-c C-.") 'delete-horizontal-space) ;周りの空白を削除(Macでは＼の位置がことなるため)
(define-key global-map (kbd "C-,") 'delete-trailing-whitespace)  ;行末の空白文字削除
(define-key global-map (kbd "C-c C-i") 'align)                   ;align(桁揃え。縦に揃える)
(define-key global-map (kbd "C-c C-u") 'align-regexp)            ;align-regexp(揃える基準の文字を指定できる)
(define-key global-map (kbd "C-c 3") 'query-replace)             ;置換(対話式)M-%が押しにくいので
(define-key global-map (kbd "C-c C-3") 'replace-string)          ;置換(一括)
(define-key global-map (kbd "C-c 4") 'query-replace-regexp)      ;置換(対話式)正規表現ありC-M-%が押しにくいので
(define-key global-map (kbd "C-c C-4") 'replace-regexp)          ;置換(一括)正規表現あり
(define-key global-map (kbd "C-c m s") 'se/make-summary-buffer)  ;バッファのサマリ表示
(define-key global-map (kbd "C-x w h") 'highlight-regexp)        ;highlight-regexp(最初はなぜかこのキーバインドが使えない。解除はC-x w r)
(define-key global-map (kbd "C-@") 'hippie-expand)               ;hippie-expand(略語展開、補完を行う)
(define-key global-map (kbd "C-c C-a") 'sort-lines)              ;sort-lines(これを登録したので、降順はC-u C-c C-a)

(define-key global-map (kbd "C-c C-s") 'shell-command)             ;shell-command
(define-key global-map (kbd "C-h") 'backward-delete-char-untabify) ;backspace
(define-key global-map (kbd "M-?") 'help-command)                  ;help-command
(define-key global-map (kbd "C-x k") 'kill-current-buffer)         ;バッファキル(下記で確認省略の記述あり)

;; anything
(define-key global-map (kbd "C-c C-t") 'anything-for-files)      ;anything-for-files
(define-key global-map (kbd "C-t") 'anything-for-files)          ;anything-for-files
(key-chord-define-global "tr" 'anything-resume)                  ;anything-resume(直前のanythingセッションを復元。絞込した後など便利)

;; 同時押し
(key-chord-define-global "kj" 'view-mode)          ;view-modeの有効・無効を切り替え
(key-chord-define-global "nm" 'open-junk-file)     ;MEMOファイル
(key-chord-define-global "fr" 'recentf-open-files) ;最近使ったファイルを開く

;; 括弧の対応()
(require 'paredit)
;; M-(:括弧で囲む(リージョン部分)
(define-key global-map (kbd "M-\)") 'paredit-splice-sexp) ;括弧を外す
(define-key global-map (kbd "C-c M-s") 'paredit-split-sexp)   ;括弧を分割して増やす

;; 関数の折りたたみ、展開(fold-dwin.el)下記で読み込みしている
(define-key global-map (kbd "C-c f d") 'hs-minor-mode)        ;折りたたみのマイナーモードの有効、無効切り替え(hideshow.el)
(define-key global-map (kbd "<f12>") 'fold-dwim-toggle)       ;その部分を閉じる・展開のトグル
(define-key global-map (kbd "S-<f12>") 'fold-dwim-hide-all)   ;すべて閉じる
(define-key global-map (kbd "S-M-<f12>") 'fold-dwim-show-all) ;すべて展開する

;; [global unset key]
(global-unset-key "\e\e")                       ;ESC ESC を無効にする

;; 半画面スクロール(View-modeにあるものを通常でも)
(define-key global-map (kbd "C-M-;")
  '(lambda () (interactive) (scroll-down (/ (window-height) 2)))) ;half ↑(view-mode[u])
(define-key global-map (kbd "C-M-:")
  '(lambda () (interactive) (scroll-up (/ (window-height) 2)))) ;half ↓(view-mode[:])

;; 1行スクロール(View-modeにあるものを通常でも)
(define-key global-map (kbd "M-ESC") '(lambda (arg) (interactive "p") (scroll-down arg))) ;scroll ↑(view-mode[p]) M-ESC:C-M-[
(define-key global-map (kbd "C-M-]") '(lambda (arg) (interactive "p") (scroll-up arg))) ;scroll ↓(view-mode[n])

;; 分割したwindowでの操作
(define-key global-map (kbd "C-;") 'other-window)                      ;分割したウィンドウ間の移動(正方向)
(define-key global-map (kbd "C-:")                                     ;分割したウィンドウ間の移動(負方向)
  #'(lambda (arg) (interactive "p") (other-window (- arg))))           ;
(define-key global-map (kbd "S-<left>") 'shrink-window-horizontally)   ;分割したウィンドウサイズ変更(shift + ←)
(define-key global-map (kbd "S-<right>") 'enlarge-window-horizontally) ;分割したウィンドウサイズ変更(shift + →)
(define-key global-map (kbd "S-<up>") 'shrink-window)                  ;分割したウィンドウサイズ変更(shift + ↑)
(define-key global-map (kbd "S-<down>") 'enlarge-window)               ;分割したウィンドウサイズ変更(shift + ↓)

;; perlやrubyの正規表現を使えるようにする
(require 'foreign-regexp)
(custom-set-variables
 '(foreign-regexp/regexp-type 'perl)    ;perl or ruby
 '(reb-re-syntax 'foreign-regexp))
;; M-s M-% : Query Replace 置換(問い合わせあり。! で一括変換) 参照文字は$1,$2,...
;; M-s M-s : iSearch インクリメンタルサーチ
;; M-s M-r : iSearch backward 逆方向へインクリメンタルサーチ
;; M-s M-o : Occur バッファ内でマッチする位置の行を別バッファで確認
;; M-s M-l : re-builder そのバッファ内で正規表現をテストできる
;; M-s M-\ : 選択範囲のメタ文字(!*{}[]@など)にバックスラッシュを一括でつける


;; undo-treeの設定(load-pathを定義しなくてもなったぞ？)
;; C-x u でtree表示
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; point-undoの設定(load-pathを定義しなくてもなったぞ？)
(when (require 'point-undo nil t)
  (define-key global-map (kbd "<f7>") 'point-undo)
  (define-key global-map (kbd "S-<f7>") 'point-redo)
)

;; wgrepの設定(*grep*バッファ内で直接編集)
(require 'wgrep nil t)
;; *grep*バッファで、C-c C-p:編集、C-x C-s:編集完了(この時点ではファイルは編集中)、C-c C-k:編集破棄
;; M-x wgrep-save-all-buffers:編集内容の一括保存

;; wdired
(require 'dired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;; *dered*バッファで、r:編集、C-x C-s(or C-c C-c):編集完了、C-c C-k:編集破棄

;; ediffの設定
(setq ediff-window-setup-function 'ediff-setup-windows-plain) ;Ediff Control Panel専用のフレームを作成しない
(setq ediff-split-window-function 'split-window-horizontally) ;ediffのバッファを上下ではなく左右に並べる

;; cua-modeの設定
(cua-mode t)
(setq cua-enable-cua-keys nil)
;; C-RETを押して選択(もしくはC-SPCで通常選択してからC-RET)で、矩形選択。あとも文字挿入したり、コピー・切り取りしたり。
;; 矩形選択状態で、M-o:空白挿入、M-n:ナンバリング(開始番号、加算、表示形式を入力)

;; 矩形を選択しやすくする
;; (require 'sense-region)
;; (sense-region-on)
;; 通常リージョン選択した後、C-SPCで矩形に。そのあとは各コマンド(C-w, M-w, C-y, M-%, C-M-%)
;; C-SPCの連打も使えそう(大きな範囲ごとに選択していく)
;; インストールは手動で、しかもコピペでファイルを作成(~/.emacs.d/elisp/sense-region.el)
;; https://gist.github.com/tnoda/1776988#file-sense-region-el

;; MEMO(使い捨て)ファイル(orgファイルにする)
(require 'open-junk-file)
(setq open-junk-file-format "~/.emacs.d/junk/%Y/%Y%m%d-%H%M%S.org") ;fileパス、file名

;; 最近使ったファイルを開く(recentf-ext.el)
(setq recentf-max-saved-items 500)      ;最近使ったファイルの保存数
(setq recentf-exclude '("/TAGS$" "/var/tmp/"));最近使ったファイルに加えないファイルを正規表現で指定する
(require 'recentf-ext)
;; M-x recentf-open-files

;; Emacs内のシェルコマンド実行履歴を保存する
(require 'shell-history)
;; M-x shell-add-to-historyは実行せず履歴のみ残せる(カラ実行)

;; hippie-expand(略語展開、補完を行う)補完を行う順番を記述
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially   ;ファイル名の一部
        try-complete-file-name             ;ファイル名全体
        try-expand-all-abbrevs             ;静的略語展開
        try-expand-dabbrev                 ;動的略語展開(カレントバッファ)
        try-expand-dabbrev-all-buffers     ;動的略語展開(全バッファ)
        try-expand-dabbrev-from-kill       ;動的略語展開(キルリング：M-w/C-wの履歴)
        try-complete-lisp-symbol-partially ;Lispシンボル名の一部
        try-complete-lisp-symbol           ;Lispシンボル名全体
        ))

;; bm.el(カーソル位置を記録する)
(setq-default bm-buffer-persistence nil)
(setq bm-restore-repository-on-load t)
(require 'bm)
(add-hook 'find-file-hooks 'bm-buffer-restore)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(global-set-key (kbd "M-SPC") 'bm-toggle)
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)

;; タブ等を可視化する
(require 'whitespace)
(setq whitespace-line-column 80)        ;1行が80行を超えたら長すぎると判断
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         lines-tail     ;長すぎる行のうちwhitespace-line-column以降のみ対象
                         ;; spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))
(setq whitespace-display-mappings
      '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)") ;スペースは全角のみを可視化
;; (setq whitespace-action '(auto-cleanup)) ;保存前に自動でクリーンアップ
(global-whitespace-mode 1)
(defvar my/bg-color "DarkSlateGray")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline nil)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)

;; view-modeの各設定
(setq view-read-only t)                 ;view-modeを有効にする
;; defaultキーバインド: d / u :半ページ分スクロール
;; view-mode用キーバインドを設定
(setq view-read-only t)
(defvar pager-keybind
  `( ;; vi-like
    ;; ("h" . backward-word)
    ;; ("l" . forward-word)
    ;; ("j" . next-window-line)
    ;; ("k" . previous-window-line)
    ("h" . backward-char)               ;1文字移動(←)
    ("j" . next-line)                   ;1行移動(↓)
    ("k" . previous-line)               ;1行移動(↑)
    ("l" . forward-char)                ;1文字移動(→)
    ("0" . beginning-of-line)           ;行の先頭
    ("\$" . end-of-line)                ;行の最後
    ("y" . beginning-of-buffer)         ;バッファの先頭
    ("o" . end-of-buffer)               ;バッファの最後
    ;; (";" . gene-word)
    ("e" . scroll-down)                 ;1pageスクロール(↑)
    (" " . scroll-up)                   ;1pageスクロール(↓)
    (":" . View-scroll-half-page-forward) ;half-page移動(↓)(↑はu)
    ;; w3m-like
    ;; ("m" . gene-word)
    ;; ("i" . win-delete-current-window-and-squeeze)
    ("w" . forward-word)                ;単語移動
    ("b" . backward-word)               ;単語移動
    ;; ("(" . point-undo)
    ;; (")" . point-redo)
    ;; ("J" . ,(lambda () (interactive) (scroll-up 1)))
    ;; ("K" . ,(lambda () (interactive) (scroll-down 1)))
    ("n" . ,(lambda () (interactive) (scroll-up 1)))     ;スクロールUP(カーソルは画面が切れるまで移動しない)↑
    ("p" . ,(lambda () (interactive) (scroll-down 1)))   ;スクロールUP(カーソルは画面が切れるまで移動しない)↓
    ;; bm-easy
    ("m" . bm-toggle)                   ;行にマークを付ける
    ("[" . bm-previous)                 ;マーク行に移動
    ("]" . bm-next)                     ;マーク行に移動
    ;; langhelp-like
    ;; ("c" . scroll-other-window-down)
    ;; ("v" . scroll-other-window)
    ))
(defun define-many-keys (keymap key-table &optional includes)
  (let (key cmd)
    (dolist (key-cmd key-table)
      (setq key (car key-cmd)
            cmd (cdr key-cmd))
      (if (or (not includes) (member key includes))
        (define-key keymap key cmd))))
  keymap)
(defun view-mode-hook0 ()
  (define-many-keys view-mode-map pager-keybind)
  (hl-line-mode 1)
  (define-key view-mode-map " " 'scroll-up))
(add-hook 'view-mode-hook 'view-mode-hook0)

(require 'viewer)
;; 書き込み不能な場合はview-modeを抜けないように
(viewer-stay-in-setup)
;; 色名を指定(viwe-modeのときに色をつけてわかりやすくする)
(setq viewer-modeline-color-unwritable "tomato") ;書き込み不可ファイル
(setq viewer-modeline-color-view "orange")       ;書き込み可能でview-modeにしたファイル
(viewer-change-modeline-color-setup)
;; 特定のファイルをview-modeで開く(.logとか編集しないファイル)
(setq view-mode-by-default-regexp "\\.log$")

;; フレームに関する設定
(size-indication-mode t)                ;ファイルサイズを表示
(setq frame-title-format "%f %Z")       ;タイトルバーにファイルのフルパスを表示(%Zで文字コードと改行コードも)
(global-linum-mode t)                   ;行番号を常に表示(すべてのバッファに)
(setq-default tab-width 4)              ;TABの表示幅(初期値は8)
(setq-default indent-tabs-mode nil)     ;インデントにタブ文字を使用しない

(global-hl-line-mode t)                 ;現在行のハイライト

;; paren-mode:対応する括弧を強調する
(setq show-paren-delay 0)                             ;表示までの秒数。デフォルト0.125
(show-paren-mode t)                                   ;有効化
(setq show-paren-style 'expression)                   ;parenのスタイル:expressionは括弧内も強調
(set-face-background 'show-paren-match-face nil)      ;バックグラウンド(色)なし
(set-face-underline-p 'show-paren-match-face "green") ;括弧にカーソル合わせるとその括弧内の文にアンダーライン

;; カーソル位置にあるElisp関数や変数の情報をエコーエリアに表示する
;; hookを利用
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))
;; emacs-lisp-modeのフックをセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; 表示バッファを入れ替える(4分割の場合、反時計回り方向のバッファと次々入れ替える)
(defun my-swap-buffer ()
  "Swap buffers with next window"
  (interactive)
  (let* ((current (selected-window))
         ;; Zero means this does not select minibuffer even if it's active
         (other (next-window current 0))
         (current-buf (window-buffer current)))
    (unless (or (eq current other)
                (window-minibuffer-p current))
      (set-window-buffer (selected-window) (window-buffer other))
      (set-window-buffer other current-buf)
      (select-window other))))
(define-key global-map (kbd "<f8>") `my-swap-buffer)

;; color-moccurの設定

;; 同じコマンドを連続実行したときの振る舞いが変わる(C-a C-e M-u M-l M-c等)
(when (require 'sequential-command-config nil t)
  (sequential-command-setup-keys))

;; C-aで「行頭」と「非空白文字の先頭」をトグル的に移動
;; (defun move-beginning-alt()
;;   (interactive)
;;   (if (bolp)
;;       (back-to-indentation)
;;     (beginning-of-line)))
;; (define-key global-map "\C-a" 'move-beginning-alt)

;; 現在の日付の挿入
(setq system-time-locale "C")        ;曜日を英語表記にするために必要(らしい)
(defun insert-current-date()
  (interactive)
  (insert (format-time-string "%Y/%m/%d(%a)" (current-time))))
(define-key global-map (kbd "C-c C-;") `insert-current-date)

;; 現在の日付の挿入(数字のみ)
(defun insert-current-date-num-only()
  (interactive)
  (insert (format-time-string "%Y%m%d" (current-time))))
(define-key global-map (kbd "C-c C-]") `insert-current-date-num-only)

;; 現在の時刻の挿入
(defun insert-current-time()
  (interactive)
  (insert (format-time-string "%H:%M:%S" (current-time))))
(define-key global-map (kbd "C-c C-:") `insert-current-time)

;;括弧の補完
(electric-pair-mode 1)
;; ()[]{}""「」【】『』が補完される
;; '|<等はされない(やるならばskeleton-pairで個別設定する)

;; (global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "|") 'skeleton-pair-insert-maybe)
;; (setq skeleton-pair 1)

;; [プログラミング言語関連]---------

;; auto-completeの設定
(when (require 'auto-complete-config nil t)
  (global-auto-complete-mode 1)
  ;; (require 'auto-complete)        ;これはいらんのかな？とりあえずコメントアウト
  (define-key ac-complete-mode-map (kbd "C-n") 'ac-next)     ;候補が出たときのキーバインド
  (define-key ac-complete-mode-map (kbd "C-p") 'ac-previous) ;候補が出たときのキーバインド
  (ac-config-default))                                       ;自動で出るように

;; 現在の関数名を常に表示
(which-func-mode 1)
(setq which-func-modes t)

;; バッファのサマリを表示
(require 'summarye)
;; M-x se/make-summary-bufferで実行(プログラムの場合は関数のリスト、それ以外はキーワードが聞かれる)
;; p,nで関数移動、b,SPCでその関数の前後移動(リストのバッファにいながら閲覧できる)

;; 関数の折りたたみ、展開
(require 'hideshow)
(require 'fold-dwim)

;; 構文チェック
;; flymake
(add-hook 'perl-mode-hook (lambda () (flymake-mode t)))

;; flymake-ruby
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; Perl
;; perl-mode-hook用の関数を定義
(defun perl-mode-hooks ()
  (define-key perl-mode-map (kbd "'") 'skeleton-pair-insert-maybe)
  ;; (define-key perl-mode-map (kbd "/") 'skeleton-pair-insert-maybe)
  )
(add-hook 'perl-mode-hook 'perl-mode-hooks) ;perl-mode-hookに追加

;; Ruby
;; ruby-electricをロードする前に括弧の補完を無効にする(個別に設定したのが取られないように。do-endは残る)
(setq ruby-electric-mode-map
      (let ((map (make-sparse-keymap)))
        (define-key map " " 'ruby-electric-space/return)
        (define-key map [remap delete-backward-char] 'ruby-electric-delete-backward-char)
        (define-key map [remap newline] 'ruby-electric-space/return)
        (define-key map [remap newline-and-indent] 'ruby-electric-space/return)
        map))

;; 括弧等の自動挿入
(require 'ruby-electric nil t)
;; endに対応する行のハイライト
(when (require 'ruby-block nil t)
  (setq ruby-block-highligh-toggle t))

;; ruby-mode-hook用の関数を定義
(defun ruby-mode-hooks ()
  (define-key ruby-mode-map (kbd "'") 'skeleton-pair-insert-maybe)
  ;; (define-key ruby-mode-map (kbd "/") 'skeleton-pair-insert-maybe)
  (ruby-electric-mode t)
  (ruby-block-mode t))
(add-hook 'ruby-mode-hook 'ruby-mode-hooks) ;ruby-mode-hookに追加

;; rcodetoolsの設定(返り値をコメントに出力)
(require 'rcodetools)
(define-key ruby-mode-map (kbd "C-M-p") 'xmp)
;; M-;2回で#=>, その状態でC-M-pを実行すると出力される。ただし、パスに日本語があると、エラーになる。

;; 表示色の設定(font-lock-modeを仕様)

(global-font-lock-mode t)

;; Some new Colors for Font-lock
(setq font-lock-mode-maximum-decoration t)
(require 'font-lock)

(setq font-lock-use-default-fonts nil)
(setq font-lock-use-default-colors nil)

;; 文字列
(copy-face 'default 'font-lock-string-face)
(set-face-foreground 'font-lock-string-face "SkyBlue")
(set-face-bold-p 'font-lock-string-face nil)

;; コメント
(copy-face 'italic 'font-lock-comment-face)
(set-face-foreground 'font-lock-comment-face "orange")
(set-face-bold-p 'font-lock-comment-face nil)

;; 関数名
(copy-face 'bold 'font-lock-function-name-face)
(set-face-foreground 'font-lock-function-name-face "Cyan1")
(set-face-underline-p 'font-lock-function-name-face nil)

;; キーワード
(copy-face 'default 'font-lock-keyword-face)
(set-face-foreground 'font-lock-keyword-face "LightSteelBlue")
(set-face-bold-p 'font-lock-keyword-face nil)

;; 型名
(copy-face 'default 'font-lock-type-face)
(set-face-foreground 'font-lock-type-face "Green")
(set-face-bold-p 'font-lock-type-face nil)

;; 変数名
(copy-face 'default 'font-lock-variable-name-face)
(set-face-foreground 'font-lock-variable-name-face "Yellow")
(set-face-bold-p 'font-lock-variable-name-face nil)

;; ???
(copy-face 'default 'font-lock-reference-face)
(set-face-foreground 'font-lock-reference-face "gray")
(set-face-bold-p 'font-lock-reference-face nil)

;; warning??
(copy-face 'default 'font-lock-warning-face)
(set-face-foreground 'font-lock-warning-face "Red")
(set-face-bold-p 'font-lock-warning-face nil)

;; const (caseのラベル)
(copy-face 'default 'font-lock-constant-face)
(set-face-foreground 'font-lock-constant-face "Red")
(set-face-bold-p 'font-lock-constant-face nil)

;; 不明
(copy-face 'default 'font-lock-highlighting-face)
(set-face-foreground 'font-lock-highlighting-face "Green")
(set-face-bold-p 'font-lock-highlighting-face nil)

;; (include, ifdef 等)
(copy-face 'default 'font-lock-builtin-face)
(set-face-foreground 'font-lock-builtin-face "magenta")
(set-face-bold-p 'font-lock-builtin-face t)

;; タブ、全角空白、改行前にあるスペースやタブを強調する
;; (defface my-face-b-1 '((t (:background "#375757"))) nil) ;全角空白
;; (defface my-face-b-2 '((t (:background "#375757"))) nil) ;タブ
;; (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil) ;改行前にあるスペースやタブ
;; (defvar my-face-b-1 'my-face-b-1)
;; (defvar my-face-b-2 'my-face-b-2)
;; (defvar my-face-u-1 'my-face-u-1)
;; (defadvice font-lock-mode (before my-font-lock-mode ())
;;   (font-lock-add-keywords
;;    major-mode
;;    '(("\t" 0 my-face-b-2 append)
;;      ("　" 0 my-face-b-1 append)
;;      ("[ \t]+$" 0 my-face-u-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)

;; kill-buffer(確認を省略)
(defun kill-current-buffer ()
  "Kill the current buffer, without confirmation."
  (interactive)
  (kill-buffer (current-buffer)))

;; default mode for new buffers
(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda ()
     (auto-fill-mode ())
     ))

;; 自動改行をoffにする(↑はちがうのか？)
(setq text-mode-hook 'turn-off-auto-fill)

;; バックアップ
(setq make-backup-file nil)      ;バックアップファイルを作らない
(setq backup-inhibited t)        ;これ2つでセットのようだ

;; isearch実行中に、C-kを押すと、ミニバッファの文字列に日本語もできるようになる
(define-key isearch-mode-map (kbd "C-k") 'isearch-edit-string)

