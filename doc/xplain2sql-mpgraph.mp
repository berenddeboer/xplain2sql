% collected graphics of job "xplain2sql"
mpgraph:=4000;
randomseed:=20;
_special_div_ := 10000; 
if unknown context_tool: input mp-tool; fi;
if unknown context_spec: input mp-spec; fi;
if unknown context_grph: input mp-grph; fi;

graphictextformat:="context";
graphictextdirective "\global \loadfontfileoncetrue ";

string contextversion;
contextversion:="2008.05.21 15:21";

boolean collapse_data; collapse_data:=true;
def data_mpd_file = "xplain2sql-mp.mpd" enddef ;
def data_mpo_file = "xplain2sql-mp.mpo" enddef ;
def data_mpy_file = "xplain2sql-mp.mpy" enddef ;


color OverlayColor,OverlayLineColor;

def initialize_form_numbers =
do_initialize_numbers;
enddef;

vardef ForegroundBox =
unitsquare xysized(HSize,VSize)
enddef ;
vardef PageFraction =
if 50>1: (33-1)/(50-1) else: 1 fi
enddef ;

string txtfile ; txtfile := "xplain2sql-mpgraph.mpb" ;
string txtfont ; txtfont := "texnansi-lmtt10" ;
string txtpref ; txtpref := "00001::::" ;

if unknown context_page: input mp-page; fi;

boolean PageStateAvailable,OnRightPage,InPageBody;
PageStateAvailable:=true;

path PlainTextArea;

if unknown context_core : input mp-core.mp ; fi ;
;
defaultfont:="ec-lmr10";
defaultscale:=11.0pt/10pt;

cmykcolors:=true;
spotcolors:=true;

OverlayWidth:=392.64812pt  ;
OverlayHeight:=597.51323pt  ;
OverlayDepth:=597.51323pt  ;
OverlayColor:=(0,0,0);
OverlayLineWidth:=0pt ;
OverlayLineColor:=(0,0,0);
BaseLineSkip:=-1000.0pt;
LineHeight:=-1000.0pt;
BodyFontSize:=11.0pt;
TopSkip:=11.0pt;
StrutHeight:=9.54787pt;
StrutDepth:=3.71303pt;
CurrentWidth:=392.64812pt;
CurrentHeight:=597.51323pt;
EmWidth:=11.0pt;
ExHeight:=4.73604pt;
PageNumber:=32;
RealPageNumber:=33;
LastPageNumber:= 50;

prologues:=1;
mpprocset:=1;

HSize:=392.64812pt;
VSize:=597.51323pt;

mp_shade_version := 2 ;

OnRightPage:=true;
InPageBody:=false ;

def LoadPageState =
OnRightPage:=true;
OnOddPage:=true;
RealPageNumber:=33;
PageNumber:=32;
NOfPages:=50;
PaperHeight:=845.04684pt;
PaperWidth:=597.50787pt;
PrintPaperHeight:=845.04684pt;
PrintPaperWidth:=597.50787pt;
TopSpace:=71.12546pt;
BottomSpace:=62.60228pt;
BackSpace:=99.58464pt;
CutSpace:=105.27512pt;
MakeupHeight:=711.3191pt;
MakeupWidth:=392.64812pt;
TopHeight:=0.0pt;
TopDistance:=0.0pt;
HeaderHeight:=56.90294pt;
HeaderDistance:=0.0pt;
TextHeight:=597.51323pt;
FooterDistance:=0.0pt;
FooterHeight:=56.90294pt;
BottomDistance:=0.0pt;
BottomHeight:=0.0pt;
LeftEdgeWidth:=0.0pt;
LeftEdgeDistance:=0.0pt;
LeftMarginWidth:=75.58197pt;
LeftMarginDistance:=11.99829pt;
TextWidth:=392.64812pt;
RightMarginDistance:=11.99829pt;
RightMarginWidth:=75.58197pt;
RightEdgeDistance:=0.0pt;
RightEdgeWidth:=0.0pt;
InnerMarginDistance:=11.99829pt;
InnerMarginWidth:=75.58197pt;
OuterMarginDistance:=11.99829pt;
OuterMarginWidth:=75.58197pt;
InnerEdgeDistance:=0.0pt;
InnerEdgeWidth:=0.0pt;
OuterEdgeDistance:=0.0pt;
OuterEdgeWidth:=0.0pt;
PageOffset:=0.0pt;
PageDepth:=0.0pt;
LayoutColumns:=1;
LayoutColumnDistance:=0.0pt;
LayoutColumnWidth:=392.64812pt;
enddef;

ResetTextAreas;
;
SaveTextAreas;
ResetTextAreas;
;
;
PlainTextArea:=boundingbox((99.58464pt,119.50522pt)--(99.58464pt,119.50522pt)
shifted (392.64812pt,597.51323pt));

local_multi_par_area:=true;
;
let mprunend = end ;
beginfig(4000);
if unknown context_char : input mp-char.mp ; fi ; grid_width := 88.0pt; grid_height := 71.5pt; shape_width := 66.0pt; shape_height := 49.5pt; connection_line_width := 1.64993pt; connection_smooth_size := 4.125pt; connection_arrow_size := 4.125pt; connection_dash_size := 4.125pt; begin_chart(0,6,1); reverse_y := true ; chart_offset := 4.125pt; chart_background_color := (scaledgray(1,1)) ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(1,1,shape_singledocument) ; end_sub_chart ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(2,1,shape_procedure) ; end_sub_chart ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(3,1,shape_procedure) ; end_sub_chart ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(4,1,shape_procedure) ; end_sub_chart ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(5,1,shape_procedure) ; end_sub_chart ; begin_sub_chart ; shape_line_color := (scaledgray(.7,1)) ; shape_fill_color := (scaledgray(.9,1)) ; shape_line_width := 1.64993pt; peepshape := false ; new_shape(6,1,shape_singledocument) ; end_sub_chart ; smooth := true ; dashline := false ; arrowtip := true ; touchshape := true ; dsp_x := 0 ; dsp_y := 0 ;connection_line_color := (scaledgray(.5,1)) ; connection_line_width := 1.64993pt; connect_right_left(1,1,0) (2,1,0) ; dsp_x := 0 ; dsp_y := 0 ;smooth := true ; dashline := false ; arrowtip := true ; touchshape := true ; dsp_x := 0 ; dsp_y := 0 ;connection_line_color := (scaledgray(.5,1)) ; connection_line_width := 1.64993pt; connect_right_left(2,1,0) (3,1,0) ; dsp_x := 0 ; dsp_y := 0 ;smooth := true ; dashline := false ; arrowtip := true ; touchshape := true ; dsp_x := 0 ; dsp_y := 0 ;connection_line_color := (scaledgray(.5,1)) ; connection_line_width := 1.64993pt; connect_right_left(3,1,0) (4,1,0) ; dsp_x := 0 ; dsp_y := 0 ;smooth := true ; dashline := false ; arrowtip := true ; touchshape := true ; dsp_x := 0 ; dsp_y := 0 ;connection_line_color := (scaledgray(.5,1)) ; connection_line_width := 1.64993pt; connect_right_left(4,1,0) (5,1,0) ; dsp_x := 0 ; dsp_y := 0 ;smooth := true ; dashline := false ; arrowtip := true ; touchshape := true ; dsp_x := 0 ; dsp_y := 0 ;connection_line_color := (scaledgray(.5,1)) ; connection_line_width := 1.64993pt; connect_right_left(5,1,0) (6,1,0) ; dsp_x := 0 ; dsp_y := 0 ;clip_chart(1,1,6,1) ; end_chart ; 
endfig;
let end=mprunend;
end.
