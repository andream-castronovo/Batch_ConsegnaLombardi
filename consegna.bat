@echo off

set intro=false
if %intro% EQU true (
echo Cambia le prime righe del codice per impostare i percorsi vari
echo dopo elimina queste 4 righe di codice 
echo ^(Tasto destro, apri con, notepad^)
echo.
echo Se vuoi che questo programma faccia anche il commit con git in caso ti dimentichi, metti la variabile "git=true"
echo.
pause
goto :EOF
)

REM Variabili da cambiare
set TecnProg=Z:\TecnProg
set Informatica=Z:\Informatica
set git=true
set chiudiVisualStudio=true

REM Variabile da non cambiare
set data=%date:~6%-%date:~3,2%-%date:~0,2%

REM Chiedi il percorso
:promptPercorso
set /p percorso=Inserisci il percorso da consegnare senza virgolette anche se ci sono spazi --^> 
if not exist "%percorso%" ( echo Il percorso non esiste & goto :promptPercorso )


REM Chiedi che materia è da consegnare
:promptMateria
set /p materia=tps o info^? --^> 
if not %materia% EQU tps (
   if not %materia% EQU info (
      echo Valori accettati: "info" o "tps"
      goto :promptMateria
   )
)

REM Chiudi VisualStudio
if chiudiVisualStudio EQU false goto :promptMateria
tasklist /fi "imagename eq devenv.exe" | find ":" > nul
if errorlevel 1 taskkill /F /IM "devenv.exe"

cd /D "%percorso%"

REM Elimina tutte le cartelle bin/ obj/ e .vs/ ed il loro contenuto
:binobjvs
FOR /d /r . %%d IN (bin) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (obj) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (.vs) DO @IF EXIST "%%d" rd /s /q "%%d"

REM Effettua l'add, il commit e il push se è stato dimenticato
:git 
if %git% EQU true ( echo. & echo ^> Git Add ^< & echo. & git add . & echo. & echo ^> Git Commit ^< & echo. & git commit -m "Commit automatico consegna %data%" & echo. & echo ^> Git push ^< & echo. & git push & echo.)

REM Crea la cartella con il formato di data che vuole il prof

echo ^> Creo la cartella con il formato di data che vuole il prof ^<
echo.

if not %materia% EQU tps ( goto :info )

if exist %TecnProg% ( cd /D %TecnProg% ) else ( echo Cartella TecnProg inesistente ^(Prova a cambiare il percorso in questo file^) & pause & goto :EOF)

if not exist %TecnProg%\%data% ( mkdir %data% )

cd /D %TecnProg%\%data%


goto :copyFolder

:info

if exist %Informatica% ( cd /D %Informatica% ) else ( echo Cartella Informatica inesistente ^(Prova a cambiare il percorso in questo file^) & pause & goto :EOF)

if not exist %Informatica%\%data% ( mkdir %data% )

cd /D %Informatica%\%data%

:copyFolder
REM Per ottenere il nome della cartella dal percorso
for %%i IN ("%percorso%") DO (set filename=%%~ni)
mkdir "%filename%"
cd %filename%

echo ^> Copio il contenuto di %percorso% in %cd% ^<
echo.

xcopy /E /H /Y "%percorso%" .\

explorer ..\
pause