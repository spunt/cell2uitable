# cell2uitable
MATLAB tool to display cell array in properly sized uitable with menu option to print to CSV

 USAGE: h = cell2uitable(data, colnames, tabtitle)
__________________________________________________________________________
 INPUTS
    data:       cell array of data (if otherwise, will convert to cell)
    colnames:   cell array of column names (default = 1,...,N)
    tabtitle:   title of uitable (default = 'Cell Array')
__________________________________________________________________________
 EXAMPLE USAGE
  mydata      = num2cell(randn(20, 3));
  mycolnames  = {'Variable 1' 'Variable 2' 'Variable 3'}; 
  mytabtitle  = 'My Data Table'; 
  h = cell2uitable(mydata, mycolnames, mytabtitle); 


---------------------- Copyright (C) 2015 Bob Spunt ----------------------
    Created:  2015-02-03
    Email:    spunt@caltech.edu
__________________________________________________________________________
