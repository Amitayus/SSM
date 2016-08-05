function SetPlotOptions
% Set Matlab plot options according to my personal preferences (thanks Rick)
close all
set( 0, 'DefaultAxesFontSize', 16 )
set( 0, 'DefaultAxesFontName',  'Times New Roman' )
set( 0, 'DefaultAxesFontAngle', 'normal' )
gridState = 'off' ;
set( 0, 'DefaultAxesXGrid', gridState )
set( 0, 'DefaultAxesYGrid', gridState )
set( 0, 'DefaultAxesZGrid', gridState )
set( 0, 'DefaultTextFontSize', 16 )
set( 0, 'DefaultTextFontName', 'Times New Roman' )
set( 0, 'DefaultAxesColor',   'w', ...
        'DefaultAxesXColor',  'k', ...
        'DefaultAxesYColor',  'k', ...
        'DefaultAxesZColor',  'k', ...
        'DefaultTextColor',   'black', ...
        'DefaultLineColor',   'black' )
set( 0, 'DefaultLineLineWidth', 1 )
set( 0, 'DefaultUicontrolBackgroundColor', 'w' )
set( 0, 'DefaultAxesBox', 'on')
set( 0, 'FixedWidthFontName', 'Times New Roman')