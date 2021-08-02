CLS
:MENU
@echo off
@ECHO.
@ECHO ### PETRORIO SA ###
@ECHO ...............................................
@ECHO Sistema de Clone Windows 10 2H21
@ECHO Por Carlos Eduardo Barbosa Jul/21
@ECHO MANTENHA O COMPUTADOR CONECTADO NA FONTE!
@ECHO ...............................................
@ECHO.
@ECHO Versao da imagem desejada:
@ECHO.
@ECHO 1 - Dell Latitude 3410
@ECHO 2 - Dell Latitude 7000
@ECHO 3 - Windows 10 Generico (Sysprep)
@ECHO 4 - Windows 10 - Pre Linux (Sysprep)
@ECHO 5 - $ Reservado $
@ECHO 6 - $ Reservado $
@ECHO.
SET /P M=Escolha a opcao depois Enter:
IF %M%==1 GOTO 3410
IF %M%==2 GOTO 7000
IF %M%==3 GOTO GEN
IF %M%==4 GOTO SDA
IF %M%==5 GOTO EXIT
IF %M%==6 GOTO EXIT
:3410
D:\ApplyImage.bat E:\Imagens\PRIOLatitude3410.wim
GOTO MENU
:7000
D:\ApplyImage1.bat E:\Imagens\PRIOLatitude3410.wim
GOTO MENU
:GEN
D:\ApplyImageGeneric.bat E:\Imagens\PRIOSysPrep.wim
GOTO MENU
:SDA
D:\ApplyImageOnLinux.bat C:\Imagens\PRIOSysPrep.wim
:EXIT
GOTO MENU