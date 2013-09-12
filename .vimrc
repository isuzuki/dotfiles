"color
syntax on
colorscheme darkblue

"encode
set encoding=utf-8
set fileencoding=utf-8

set list
set listchars=tab:▸\ ,eol:¬

"indent
set autoindent
set cindent
set shiftwidth=4
set tabstop=4

"search
set incsearch
set hlsearch

"key move
set nocompatible
set whichwrap=b,s,h,l,<,>,[,]

"display
set number
set ruler

"status line
set laststatus=2
set statusline=%F%m%r%h%w\ [ENCORDING=%{&enc}]\ [FORMAT=%{&fileformat}]

set visualbell

"tab
nnoremap <C-h> gt
nnoremap <C-l> gT
for i in range(1, 9)
	execute 'nnoremap <Tab>' . i . ' ' . i . 'gt'
endfor

"C-w gf をtgで開けるようにする
nnoremap <silent> tg <C-w>gf
nnoremap vg :vertical wincmd f<CR>
nnoremap <silent> sg <C-w>f

"=== for PHP setting 
"syntax check
autocmd filetype php :set makeprg=php\ -l\ %
autocmd filetype php :set errorformat=%m\ in\ %f\ on\ line\ %l

"=== for NeoBundle
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#rc(expand('~/.vim/bundle/'))
endif

"get plugin from github
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'rking/ag.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'tomasr/molokai'

nmap <F1> :NeoBundleInstall<CR>

filetype plugin indent on
filetype indent on

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

"=== for vim plugin
" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_max_list = 30
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_enable_smart_case = 1
"" like AutoComplPop
let g:neocomplcache_enable_auto_select = 1
"" search with camel case like Eclipse
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
"" SuperTab like snippets behavior.
"" <CR>: close popup and save indent.
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

"vim-ref
let g:ref_phpmanual_path = $HOME . '/.vim/phpmanual'
nmap ,rp :<C-u>Ref phpmanual<Space>

"tagbar
"hide variables
let g:tagbar_type_php = {
	\ 'ctagstype' : 'php',
	\ 'kinds' : [
		\ 'i:interfaces:0:1',
		\ 'c:classes:0:1',
		\ 'd:constant definitions:0:0',
		\ 'f:functions:0:1',
		\ 'j:javascript functions:0:1'
	\ ]
\ }

nmap <F8> :TagbarToggle<CR>
autocmd VimEnter * TagbarToggle

"unite.vim
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ufa :<C-u>Unite -input=**/* file<CR>
nnoremap <silent> ,ff :<C-u>Unite file<CR>
nnoremap <silent> ,ffa :<C-u>Unite -input=**/* file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

call unite#custom_default_action('file', 'tabopen')

"vimfiler
nnoremap <F2> :VimFiler -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>
autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
	nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
	nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
	nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

"Edit file by tabedit.
let g:vimfiler_edit_action = 'tabopen'

let s:my_action = { 'is_selectable' : 1 }
function! s:my_action.func(candidates)
	wincmd p
	exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', s:my_action)

let s:my_action = { 'is_selectable' : 1 }
function! s:my_action.func(candidates)
	wincmd p
	exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', s:my_action)

"giv
function! s:gitv_get_current_hash()
	return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
endfunction

autocmd FileType git setlocal nofoldenable foldlevel=0
function! s:toggle_git_folding()
	if &filetype ==# 'git'
		setlocal foldenable!
	endif
endfunction

autocmd FileType gitv call s:my_gitv_settings()
function! s:my_gitv_settings()
	setlocal iskeyword+=/,-,.
	nnoremap <silent><buffer> C :<C-u>Git checkout <C-r><C-w><CR>
	nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
	nnoremap <buffer> <Space>R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
	nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
	nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
	nnoremap <silent><buffer> t :<C-u>windo call <SID>toggle_git_folding()<CR>1<C-w>w
endfunction


" 全角スペースをハイライトさせる
function! TwoByteCharSpace()
	highlight TwoByteCharSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
	augroup TwoByteCharSpace
		autocmd!
		autocmd ColorScheme       * call TwoByteCharSpace()
		autocmd VimEnter,WinEnter * match TwoByteCharSpace /　/
	augroup END
	call TwoByteCharSpace()
endif

"set t_Co=256
set cursorline
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine term=none cterm=none ctermfg=none ctermbg=233

" カレントウィンドウのみ罫線を引く
augroup cch
	autocmd! cch
	autocmd WinLeave * set nocursorline
	autocmd WinEnter,BufRead * set cursorline
augroup END
