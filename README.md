# dynamicsuction
Dynamic Suction Pumping in IBAMR

This is a 2D code for running in Immersed Boundary Method with Adaptive Mesh Refinement (IBAMR) package and simulates dynamic suction pumping on a flexible tube with a variety of attached circulatory systems. 4/14/2015 LWALDROP

This code is set up to run on Kure or Killdevil cluster at UNC-Chapel Hill, running on an IBAMR/3803 install. Units are in SI standard units unless otherwise noted. 

Before successfully running this code, the generate_mesh2d*.m files will need to be run in MATLAB to generate the necessary *.target, *.vertex, *.spring, and *.beam files that input2d will read in and use. The current files work with  MATLAB v 2010a or later.

The base code was written by Boyce Griffith and Laura Miller and edited by Lindsay Waldrop. 4/14/2015 LWALDROP