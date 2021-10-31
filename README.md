# Introduction

Sometimes you need to write data generated in the **Simulink** model to a file. **Simulink** has a special _"To File"_ block for this task, but it can only write to a mat-file.
_"mat"_ is a scientific file format with service data. If you need binary data you need to extract it from the mat-file first.

**"MATLAB system"** block **"DataWriter"** can write binary data generated in the **Simulink** model without service data.
It uses the low-level I/O function _"fwrite"_. Writing is done over the existing file (_"w"_ mode). The block uses little-endian ordering by default.
The block can write real or complex data of types _double_, _single_, _int64_, _int32_, _int16_, _int8_ and thier unsigned forms.
For more information, see the section _"Exporting binary data using low-level I/O"_ in the **MATLAB** documentation.

# Installation

Just download _"DataWriter.m"_ file to your computer.

# How to use it?

In the **Simulink** model, add **"MATLAB System"** block and select _"DataWriter.m"_ file in its dialog box.
After that, connect the block input to your signal source.
In the block dialog box, enter an absolute file name or a relative file name (the file will be written to the current **MATLAB** folder).
And finally, select the input data type.
