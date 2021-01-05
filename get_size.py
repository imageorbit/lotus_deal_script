#!/usr/bin/env python
#coding=utf-8
import os
import sys
import math

#fun: get file size, piece size 

def get_piece_size(filename):
    file_size = os.path.getsize(filename)
    # --manual-piece-size
    manu_piece_size = int(  127*( 2**( math.ceil( math.log( math.ceil(file_size/127), 2) ) ) )   )
    piece_size = int(manu_piece_size*256/254)
    return (manu_piece_size, piece_size)


if __name__=="__main__":
    if len(sys.argv)!=2:
        print("please input filename")
        sys.exit()
    filename = sys.argv[1]
    (manu_piece_size, piece_size) = get_piece_size(filename)
    print( str(manu_piece_size)+","+str(piece_size) )
