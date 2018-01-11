input mp-tool.mpii;
verbatimtex \input dplain etex

beginfig(1);
path p, q ; p := unitsquare xscaled 90 yscaled 40;
q := p shifted (0,0); fill q withcolor white; draw q;
label(btex \vbox{\hbox{vehicle}} etex, center q);
endfig;
end;
