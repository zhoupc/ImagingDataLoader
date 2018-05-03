# Imaging Data Loader (IDL)
A unified MATLAB loader for all type of video imaging data (2D / 3D) . It can 

1. load data using the same function for all different data types. The data structure is handled internally. 
2. load a small chunk of data while optimizing I/O operations. 
3. minimize efforts for adding a support to new data types. 

For each data type, we only have to pass **the function handle** for loading data.  It currently supports following data types 

1. Tiff 
2. hdf5
3. mat 
4. avi 
5. npy 

and it provides a flexible interface for calling your customized loader. 



## Why this package? 

My work is closely related to loading scientific imaging data (e.g., calcium imaging , voltage imaging) , which are videos of 2D or 3D spaces. I received lots of data saved in different formats from our collaborators. Usually, we need different packages for loading them. Sometimes, we have to use customized function. This relates to setting up paths and changing scripts. **Thus I need a package for collecting all functions for data loading.** 

But this package is more than a collection of data-loading functions. Actually, the real annoying thing came from loading **video data of a volume space**. We all know that the loaded data is a 4D array (x-y-z-t), but people can save data in many different ways, for example, we can save all z planes into multiple files,  or we can save the whole data into one array but the orders of dimensions are different.  **Thus I want to create a wrapper to internally handle the data structure**. 

Moreover, I have to frequently **load part of data into memory.** This requires us to take care of the I/O operations. So I want this wrapper to handle these problem. 

## Download
OPTION 1: download the package using this [LINK](https://github.com/zhoupc/idl/archive/master.zip)

OPTION 2: (recommended) clone the git repository <https://github.com/zhoupc/idl.git>. In this way, you are able to get the latest updates of the package within 1-line command or 1-button click. 

## Installation
Run idl_setup.m to add IDL  to the search path of MATLAB

`>> idl_set`

## Examples
We provided some demos in .**/demos/demo_idl.m**. You can learn the usage of the package by running the demo script. 

`>> edit demos/demos_idl`

## Questions
You can ask questions by sending emails to zhoupc1988@gmail.com 



## Acknowledgements
**We used/modified the following code/packages for IDL**

1. [bigread2.m](https://github.com/dspeterka/utils/blob/master/bigread2.m) Thanks to Darcy S. Peterka
2. [saveastiff](https://www.mathworks.com/matlabcentral/fileexchange/35684-multipage-tiff-stack) Thanks to YoonOh Tak. 
3. [npy-matlab](https://github.com/kwikteam/npy-matlab.git) Thanks to [Nick Steinmetz](Nick Steinmetz)
4. [TIFFStack](https://github.com/DylanMuir/TIFFStack) Thanks to [Dylan Muir](https://github.com/DylanMuir)



## License
Copyright 2018 Pengcheng Zhou

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
