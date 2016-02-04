#!/bin/bash
ghc --make Areaplot.hs
./Areaplot results/hbmc-symbo_-q_ results/hbmc-normal_-q_ > symbo_crappy.dat
./Areaplot results/hbmc-symbo_-q_ results/_lazysc_ > symbo_lazysc.dat
./Areaplot results/hbmc-normal_-q_ results/_lazysc_ > crappy_lazysc.dat
./Areaplot results/hbmc-symbo_-q_ results/_feat_ > symbo_feat.dat
./Areaplot results/hbmc-symbo_-q_ results/smten-runner_ > symbo_smten.dat
