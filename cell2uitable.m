function h = cell2uitable(data, colnames, tabtitle)
% CELL2UITABLE Display cell array in uitable with menu option to print to CSV
% 
%  USAGE: h = cell2uitable(data, colnames, tabtitle)
% __________________________________________________________________________
%  INPUTS
% 	data:       cell array of data (if otherwise, will convert to cell)
% 	colnames:   cell array of column names (default = 1,...,N)
% 	tabtitle:   title of uitable (default = 'Cell Array')
% __________________________________________________________________________
%  EXAMPLE USAGE
%   mydata      = num2cell(randn(20, 3));
%   mycolnames  = {'Variable 1' 'Variable 2' 'Variable 3'}; 
%   mytabtitle  = 'My Data Table'; 
%   h = cell2uitable(mydata, mycolnames, mytabtitle); 
% 
% 
% ---------------------- Copyright (C) 2015 Bob Spunt ----------------------
% 	Created:  2015-02-03
% 	Email:    spunt@caltech.edu
% __________________________________________________________________________
if nargin < 1, disp('USAGE: h = cell2uitable(data, colnames, tabtitle)'); return; end
if ~iscell(data), if ischar(data), data = cellstr(data); else data = num2cell(data); end; end
if nargin < 2, colnames = num2cell(1:size(data,2)); end
if length(colnames)~=size(data, 2)
    error('Length of colnames (%d) does not equal number of columns in data (%d)', length(colnames), size(data, 2)); 
end
if nargin < 3, tabtitle = 'Cell Array'; end

% | Create Figure
tfig  = figure('pos', [.5 .5 .4 .4], ...
    'Units', 'Norm', ...
    'DockControls','off', ...
    'MenuBar', 'none', ...
    'Name', tabtitle, ...
    'Color', [1 1 1], ...
    'NumberTitle', 'off', ...
    'Visible', 'off'); 

% | Menu for Save to CSV
tfigmenu = uimenu(tfig,'Label','Option');
savemenu = uimenu(tfigmenu,'Label','Write to CSV', 'CallBack', {@cb_savetable, tfig});

% | Create Table
th = uitable('Parent', tfig, ...
    'Data', data, ...
    'Units', 'norm', ...
    'ColumnName', colnames, ...
    'Pos', [0 0 1 1], ...
    'RearrangeableColumns', 'on', ...
    'ColumnWidth', 'auto', ...
    'FontName', 'Arial', ...
    'FontUnits', 'Points');

% | Resize Table to Fit Figure
set(th, 'units', 'pix');
set(tfig, 'units', 'pix'); 
tpos    = get(th, 'extent');
fpos    = get(tfig, 'pos'); 
set(tfig, 'pos', [fpos(1:2) tpos(3:4)]);
set(th, 'units', 'norm');
set(th, 'pos', [0 0 1 1]); 
set(tfig, 'Visible', 'on');

% | Save Handles
h.fig   = tfig;
h.menu  = savemenu; 
h.tab   = th; 

end
% ==========================================================================
%
% ------------------------------ SUBFUNCTIONS ------------------------------
%
% ==========================================================================
function cb_savetable(varargin)
    t = findobj(varargin{3}, 'type', 'uitable');
    data = get(t, 'data'); 
    colnames = get(t, 'columnname'); 
    if size(colnames,2)~=size(data,2), colnames = colnames'; end
    outcell = [colnames; data]; 
    outname = sprintf('%s.csv', regexprep(get(varargin{3}, 'name'), ' ', '_')); 
    [fname, pname] = uiputfile({'*.csv', 'CSV File'; '*.*', 'All Files (*.*)'}, 'Save Table As', outname);
    writereport(outcell, fullfile(pname, fname)); 
end
function writereport(incell, outname)
% WRITEREPORT Write cell array to CSV file
%
%  USAGE: outname = writereport(incell, outname)	*optional input
% __________________________________________________________________________
%  INPUTS
%	incell:     cell array of character arrays
%	outname:   base name for output csv file 
%

% ---------------------- Copyright (C) 2015 Bob Spunt ----------------------
%	Created:  2015-02-02
%	Email:    spunt@caltech.edu
% __________________________________________________________________________
if nargin < 2, disp('USAGE: outname = writereport(incell, outname)'); return; end

% | Convert all cell contents to character arrays
% | ========================================================================
[nrow, ncol] = size(incell);
for i = 1:numel(incell)
    if isnumeric(incell{i}), incell{i} = num2str(incell{i}); end
    if strcmp(incell{i},'NaN'), incell{i} = ''; end
end
incell = regexprep(incell, ',', '');

% | Write to file
% | ========================================================================
fid = fopen(outname,'w');
for r = 1:nrow
    fprintf(fid,['%s' repmat(',%s',1,ncol-1) '\n'],incell{r,:});
end
fclose(fid);
end