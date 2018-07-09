" 此vim配置位置为 ~/.vimrc
" 高亮当前行
set cursorline
" TAB 设为四个空格
set tabstop=4
" 自动缩进
set autoindent
" 自动缩进四个空格
set shiftwidth=4
" 使用空格代替TAB
set expandtab
" 定义ShellHeader()函数用于自动插入shell文件头
function ShellHeader()
    call setline(1,"#!/bin/bash")
    normal G
    normal o
    normal o
endfunc
" 新建sh结尾的文件时自动调用ShellHeader()函数
autocmd BufNewFile *.sh call ShellHeader()

" 按下F5自动执行当前Python文件，按下F4自动执行当前shell文件
map <F4> :!clear ;bash % <CR>
