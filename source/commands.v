// Command Reference fot the SPI Interface

// Author: Matthew Knight
// Date: 2017-01-27

/* Commands:

D/C_n Pin: 
    - Input that tells the display driver if byte is command or data

Clear Screen
    - Clears all pixels

Set Screen
    - Sets all pixels

Write Data
    - Set/Clear pixels in current byte
    - pointer to current byte increments after every write

Display Control 
    - Power Display on or off

Set Y address of RAM
    - 0 to 239
    - Will need to do this in a two byte command

Set X Address of RAM
    - 0 to 39

Notes:

Resolution: 240x320 (PixelxPixel)
	    240x40 (Line x Byte)
Display Memory: 9600 bytes
*/
