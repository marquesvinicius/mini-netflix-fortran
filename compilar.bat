@echo off
cd /d "%~dp0"
gfortran mini_netflix.f90 -o mini_netflix.exe
if errorlevel 1 (echo Erro: gfortran nao encontrado ou falha na compilacao. Veja read-me.txt & pause & exit /b 1)
echo Compilado com sucesso! Rodando...
mini_netflix.exe
pause
