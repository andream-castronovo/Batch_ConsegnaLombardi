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

REM Variabile da non cambiare
set data=%date:~6%-%date:~3,2%-%date:~0,2%

REM Chiedi il percorso
:promptPercorso
set /p percorso=Inserisci il percorso da consegnare --^> 
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

cd /D "%percorso%"

REM Elimina tutte le cartelle bin/ obj/ e .vs/ ed il loro contenuto
:binobjvs
FOR /d /r . %%d IN (bin) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (obj) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (.vs) DO @IF EXIST "%%d" rd /s /q "%%d"

REM Effettua l'add, il commit e il push se è stato dimenticato
:git 
if %git% EQU true ( git add . & git commit -m "Commit automatico consegna %data%" & git push )

REM Crea la cartella con il formato di data che vuole il prof
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
xcopy /E /H /Y "%percorso%" .\

REM Ripeto il processo di eliminazione in caso qualcosa non è stato cancellato correttamente.
FOR /d /r . %%d IN (bin) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (obj) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (.vs) DO @IF EXIST "%%d" rd /s /q "%%d"
FOR /d /r . %%d IN (.git) DO @IF EXIST "%%d" rd /s /q "%%d"

explorer ..\