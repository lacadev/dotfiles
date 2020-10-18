" Path to neovim python module
let g:python3_host_prog = expand('~/.config/nvim/venv/bin/python')

set tags=tags
nmap <C-c> <Esc>

" Python debugger
autocmd FileType python nmap <buffer> <localleader>do oimport pdb; pdb.set_trace()<C-c>
autocmd FileType python nmap <buffer> <localleader>dO Oimport pdb; pdb.set_trace()<C-c>

"""""""" COLORS """"""""
" Syntax highlight
syntax on

" So that colors do not mess with vim
set background=dark

"""""""" GENERAL """"""""
nmap <C-f> <Nop>
nmap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" Reload .vimrc with <space>+s
map <silent> <leader>s :source ~/.vimrc<CR>

"Add colored column at 90 to avoid going too far to the right
"set colorcolumn=90
"hi ColorColumn ctermbg=DarkGrey guibg=lightgrey
" Terminal mode
:tnoremap <Esc> <C-\><C-n>
:tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" Enable smart-case search
set smartcase
" Together with smartcase, ignore case when using lowercase
set ignorecase
" Searches for strings incrementally
set incsearch

" Highlight all matches
set hlsearch
" Press Esc to hide highlights
nnoremap <silent> <Esc> :nohlsearch<bar>:echo<CR>
" Show number of occurrances of searched pattern
" Requires Vim 8.1.1270 and Neovim 0.4.0
set shortmess-=S

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Keep more info in memory to speed things up
set hidden "this must go after nocompatible if using it
set history=100

" Some servers have issues with backup files
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Indent with logic (even though a 2 spaces width is set,
" thanks to filetype it will use its own knowledge for
" each file format, and use 2 when unknown)
" use 'filetype indent on' if you have indent style files
" use 'filetype plugin on' if you have plugins to indent
" use 'filetype indent plugin on' for both
filetype on
" Auto-indent new lines
set autoindent
" When indenting with '>' use 2 spaces width
set shiftwidth=2
" Enable smart-tabs
set smarttab
" Number of spaces per Tab
set tabstop=2
" On pressing tab, insert 2 spaces (aka use spaces i.o. tabs)
set expandtab
" Friendly reminder you can use :%retab to convert all tabs
" to white spaces if using expandtab, or just retab if not.

" Remove whitespaces at the end of line on save
" Note the final /e means not to display errors if occuring
" autocmd BufWritePre * :%s/\s\+$//e
" Remove whitespaces at the end of line
nmap <Leader>dd :s/\s\+$//e<CR>
nmap <Leader>dG :%s/\s\+$//e<CR>

" Switch to most recent buffer
nmap <silent> <leader><leader> :b#<CR>

" Open file in new tab with Ctrl+o (final whitespace is on purpose)
" nmap <C-o> :tabe
" Move through tabs with <leader>t ot <leader>T
"nmap <leader>t gt
"nmap <leader>T gT

" Keep position in window & buffer when switching among them
" https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
"
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
  if !exists("w:SavedBufView")
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
" Restore current view settings.
function! AutoRestoreWinView()
  let buf = bufnr("%")
  if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
    let v = winsaveview()
    let atStartOfFile = v.lnum == 1 && v.col == 0
    if atStartOfFile && !&diff
      call winrestview(w:SavedBufView[buf])
    endif
    unlet w:SavedBufView[buf]
  endif
endfunction
" When switching buffers, preserve window view.
if v:version >= 700
  autocmd BufLeave * call AutoSaveWinView()
  autocmd BufEnter * call AutoRestoreWinView()
endif

" Break lines at word (requires Wrap lines(it's default))
set linebreak
" Wrap-broken line prefix
" set showbreak=+++
" Highlight matching brace
set showmatch
" Display relative line numbers
set number relativenumber
" Show row and column ruler information
set ruler
" Number of undo levels
set undolevels=1000
" Backspace behaviour
set backspace=indent,eol,start
" Indent depending on file
filetype plugin indent on
" Resize splits easily
nnoremap <silent> <C-w>l :vertical resize +10<CR>
nnoremap <silent> <C-w>h :vertical resize -10<CR>
nnoremap <silent> <C-w>k :resize +10<CR>
nnoremap <silent> <C-w>j :resize -10<CR>
" Splits
nnoremap <silent> <C-w>\| :vsplit<CR>
nnoremap <silent> <C-w>- :split<CR>
" Close split
" nnoremap <silent> <Leader>q <C-w>q
" Move through windows nicely
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Move thorugh buffers nicely
nnoremap <silent> <tab> :bn<CR>
nnoremap <silent> <S-tab> :bp<CR>
nnoremap <silent> <C-q> :bp<cr>:bd #<cr>

" Some basics:
set nocompatible
set encoding=utf-8
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Splits open at the bottom and right
set splitbelow splitright

" LaTeX
" Make lines wrap at 88 chars. Set to 0 to disable
autocmd BufEnter *.tex set textwidth=88

" Plugins
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" NERDTree
Plug 'scrooloose/nerdtree'

" Vim commentary
Plug 'tpope/vim-commentary'

" Vim-surround
Plug 'tpope/vim-surround'

" Vim-repeat
Plug 'tpope/vim-repeat'

" Vim-easyclip
" Differentiate between deleting and cutting text
Plug 'svermeulen/vim-easyclip'

" Vim-signature
" Marks
Plug 'kshenoy/vim-signature'

" CtrlP (requires RipGrep)
" Fuzzy file finding
Plug 'ctrlpvim/ctrlp.vim'

" Polyglot
Plug 'sheerun/vim-polyglot'

" Vim-fugitive
Plug 'tpope/vim-fugitive'

" Vim-gutentags and gutentags_plus
" Plug 'ludovicchabant/vim-gutentags'

" Ctrlsf
" Find references of a word in the code.
Plug 'dyng/ctrlsf.vim'

" Indentline
" Show thin vertical lines when there's indentation
Plug 'Yggdroot/indentLine'

""" CSS
" Show colors
Plug 'ap/vim-css-color'

""" HTML
" Ease HTML tag writing
Plug 'mattn/emmet-vim'

" Ale
" Linting
Plug 'w0rp/ale'

" Vim-autoformat
Plug 'Chiel92/vim-autoformat'

" Coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Debugger
Plug 'puremourning/vimspector'

" Airline
Plug 'vim-airline/vim-airline'

" Airline themes
Plug 'vim-airline/vim-airline-themes'

" Tmuxline
Plug 'edkolev/tmuxline.vim'

" Vim-Tmux-navigator
Plug 'christoomey/vim-tmux-navigator'

" Dracula
Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

" Theme
set background=dark
syntax on
let g:dracula_colorterm = 0
color dracula

" Tmuxline
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_powerline_separators = 0

" IndentLine
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" Show hidden chars in Markdown and things when in the line
" " Let indentLine use current conceal options
" let g:indentLine_conceallevel  = &conceallevel
autocmd FileType markdown let g:indentLine_concealcursor = &concealcursor
autocmd FileType tex let g:indentLine_concealcursor = &concealcursor

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nmap <silent> <leader>n :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '^\.?v?env$']
let NERDTreeQuitOnOpen = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeAutoDeleteBuffer = 1 " Automatically delete the buffer of a deleted file in NERDTree
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1

" Airline
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'
set noshowmode

" Airline themes
let g:airline_theme='dracula'

" Specific config for airline in certain filetypes
" Stop airline from checking for whitespaces so that
" it doesn't output mixed-indent warnings in bib files (LaTeX)
autocmd Filetype bib AirlineToggleWhitespace

" Set mark keybind to gm instead of m, as m is for cutting with easyclip
" nnoremap gm m
let g:EasyClipUseCutDefaults = 0
nmap <leader>m <Plug>MoveMotionPlug
xmap <leader>m <Plug>MoveMotionXPlug
nmap <leader>mm <Plug>MoveMotionLinePlug
nmap <leader>M <Plug>MoveMotionEndOfLinePlug
"" disable also Ctrl P from easyclip to let CtrlP use it
let g:EasyClipUsePasteToggleDefaults = 0
"" Format after pasting
nmap <leader>cf <plug>EasyClipToggleFormattedPaste

" Vim signature
" If you want to change the color of the column: :highlight SignColumn ctermbg=green
" To set it to transparent: highlight clear SignColumn
highlight clear SignColumn

" Tagbar
nnoremap <silent> <Leader>t :TagbarToggle<CR>
let g:tagbar_map_jump = 'o'
let g:tagbar_map_togglefold = 'O'
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

" CtrlP
"" Use ripgrep
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
endif
" Set root marker
let g:ctrlp_root_markers = ['.ctrlp', '.git']
"" ignore some files
set wildignore+=*/.git/*,*/tmp/*,*.swp
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }
"" CtrlP for buffers keybind
nnoremap <Leader>b :CtrlPBuffer<CR>
"" CtrlP from home
nnoremap <Leader>p :CtrlP .<CR>

" Ctrlsf
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_position = 'left'
let g:ctrlsf_context = '-B 6 -A 4'
let g:ctrlsf_auto_close = {
    \ "normal" : 0,
    \ "compact": 0
    \}
let g:ctrlsf_auto_preview = 0
let g:ctrlsf_auto_focus = {
      \ "at": "start"
      \ }
let g:ctrlsf_mapping = {
    \ "next": { "key": "<C-j>", "suffix": "zz" },
    \ "prev": { "key": "<C-k>", "suffix": "zz" },
    \ "pquit": ["q", "<Esc>"],
    \ }

" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" For stylint, both stylint and stylint-config-recommended are needed
" (sudo npm install -g stylelint stylelint-config-recommended)
" ESLint and stylelint need config files in $HOME or project
let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'javascript': ['eslint'],
      \ 'json': ['eslint'],
      \ 'html': ['stylelint'],
      \ 'css': ['stylelint'],
      \ 'bib': ['bibclean'],
      \ }
"" lint with F4
noremap <silent> <F4> :ALELint<CR>

" Autoformat
noremap <silent> <F3> :Autoformat<CR>
let g:formatters_python = ['black']
let g:formatters_javascript = ['eslint']
" These next 3 need js-beautify. 'sudo npm install -g js-beautify'
let g:formatters_html = ['html-beautify']
let g:formatters_css = ['css-beautify']
let g:formatters_json = ['js-beautify']
" Using the dots to concat strings. Vim replaces @% for the filename
let g:formatdef_bibtex = '"bibclean ".@%'
let g:formatters_bib = ['bibtex']
" To debug: let g:autoformat_verbosemode=1
let g:formatdef_terraform = '"terraform fmt -"'
let g:formatters_terraform = ['terraform']

" Fugitive Conflict Resolution
nnoremap <silent> <leader>gd :Gvdiffsplit!<CR>
nnoremap <silent> gdh :diffget //2<CR>
nnoremap <silent> gdl :diffget //3<CR>

" Emmet-vim
let g:user_emmet_leader_key='<C-x>'

" JSONC syntax highlighting for comments
autocmd FileType json syntax match Comment +\/\/.\+$+

" coc.nvim config
" ------------------------------------------------------
 " Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion. (Mac OS maps this to changing keyboard
" layout)
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" coc#on_enter() notifies coc.nvim that <enter> has been pressed. Useful
" for multiline string autoformatting and others.
if exists('*complete_info')
  inoremap <silent> <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <silent> <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold (the time it takes to trigger is
" set by 'set updatetime='
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType scala setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of current line
xmap <leader>a  <Plug>(coc-codeaction-line)
nmap <leader>a  <Plug>(coc-codeaction-line)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Trigger for code actions
" Make sure `"codeLens.enable": true` is set in your coc config
nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>

" See https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-change-highlight-of-diagnostic-signs
highlight link CocWarningSign DraculaOrange

" Mappings for CoCList
" Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
