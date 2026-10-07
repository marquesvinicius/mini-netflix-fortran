#!/bin/sh
# Compila e executa no Linux/macOS (precisa do gfortran)
cd "$(dirname "$0")"
gfortran mini_netflix.f90 -o mini_netflix && ./mini_netflix
