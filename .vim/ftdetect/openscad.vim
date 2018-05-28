" Adapted from: https://github.com/sirtaj/vim-openscad/blob/master/ftdetect/openscad.vim

autocmd BufReadPost,BufNewFile *.scad setfiletype openscad
anoremenu 50.80.265 &Syntax.NO.OpenSCAD :call SetSyn("openscad")<CR>
