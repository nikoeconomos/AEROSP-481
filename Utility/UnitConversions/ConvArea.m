function [newval] = ConvArea(oldval,oldunit,newunit)
%
% [newval] = ConvArea(oldval,oldunit,newunit)
% written by Niko, marnson@umich.edu
% updated 23 apr 2024
%
% Convert a length value from one unit to another. Supported units are
% listed below. Input variables oldunit and newunit should take a value
% from column 2 of the following list.
%
%        Supported units        |    symbol
%       ----------------------------------
%        feet^2                 |   'ft2'
%        meters^2               |   'm2'
%
% INPUTS:
%     oldval  - numerical value, i.e. input length.
%               size/type/units: scalar, vector, or array / double / oldunit
%
%     oldunit - length unit that oldval is given in (see table).
%               size/type/units: 1-by-1 / string or char / []
%
%     newunit - length unit that user would like oldval returned in (see
%                   table).
%               size/type/units: 1-by-1 / string or char / []
%
% OUTPUTS:
%     newval  - numerical value converted from oldunit to newunit:
%               size/type/units: same size as oldval / double / newunit
%

% ----------------------------------------------------------


% {'ft2','m2'}
%    1    2 
Data = [1	0.092903	
        10.7639	   1];

% error message definition
errormsg = sprintf("Unsupported unit in length conversion. Supported units are: \n feet:           'ft' \n meters:         'm' \n kilometers:     'km' \n miles:          'mi' \n nautical miles: 'naut mi' ");


% Define old unit Index
switch oldunit
    case 'ft2'
        row = 1;
    case 'm2'
        row = 2;
    otherwise
        error(errormsg)
end

% Define new unit index
switch newunit
    case 'ft2'
        col = 1;
    case 'm2'
        col = 2;
    otherwise
        error(errormsg)
end

% Identify Scale from Data Matrix
ScaleFactor = Data(row,col);

newval = oldval.*ScaleFactor;

end
