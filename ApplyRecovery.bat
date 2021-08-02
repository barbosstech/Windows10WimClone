cls
@echo *********************************************************************
@echo.
@echo 	###### PETRORIO SA ######
@echo.
@echo	MANTENHA O COMPUTADOR CONECTADO NA FONTE!
@echo	Script de recuperacao da instalacao Windows 10 2H21.
@echo	Este processo demora em media 30 minutos
@echo	Por Carlos Eduardo Barbosa - Julho/21 v1.0
@echo.
@echo.
@echo *********************************************************************
@echo.
@echo == ApplyRecovery.bat ==
@rem *********************************************************************
@echo Verificando se o PC foi inicializado em modo BIOS ou UEFI.
wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%B
@echo            Note: delims is a TAB followed by a space.
@if x%Firmware%==x echo ERROR: Can't figure out which firmware we're on.
@if x%Firmware%==x echo        Common fix: In the command above:
@if x%Firmware%==x echo             for /f "tokens=2* delims=    "
@if x%Firmware%==x echo        ...replace the spaces with a TAB character followed by a space.
@if x%Firmware%==x goto END
@if %Firmware%==0x1 echo The PC is booted in BIOS mode. 
@if %Firmware%==0x2 echo The PC is booted in UEFI mode. 
@echo  *********************************************************************
@echo Já existe uma particao de recupecacao ? (Y or N):
@SET /P RECOVERYEXIST=(Y or N):
@if %RECOVERYEXIST%.==y. set RECOVERYEXIST=Y
@if %RECOVERYEXIST%.==Y. GOTO COPYTOTOOLSPARTITION
@if not %RECOVERYEXIST%.==Y. GOTO CREATEFFURECOVERY
@echo  *********************************************************************
:COPYTOTOOLSPARTITION
@echo  == Copiando a imagem de recover Windows RE para a particao de recuperacao. ==
md R:\Recovery\WindowsRE
xcopy /h C:\Imagens\PRIOLatitude3410.wim R:\Recovery\WindowsRE\
xcopy /h D:\Imagens\PRIOLatitude3410.wim R:\Recovery\WindowsRE\
xcopy /h E:\Imagens\PRIOLatitude3410.wim R:\Recovery\WindowsRE\
@echo  *********************************************************************
@echo  == Registrando a localizacao da particao de recuperacao. ==
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows
@echo  *********************************************************************
@IF EXIST W:\Recovery\Customizations\USMT.ppkg (GOTO CUSTOMDATAIMAGEWIM) else goto HIDEWIMRECOVERYTOOLS
:CUSTOMDATAIMAGEWIM
@echo  == Caso seja OS Compacto, sera provisionaro uma instancia unica com os pacotes de recuperacao ==
@echo.     
@echo     *Nota: Este pacote so ira funcionar caso tenha sido criado o pacote 
@echo      USMT.ppkg dentro do OEM Deployment lab. Caso negativo, escolha N.
@echo.      
@echo     Opcoes:  N: No
@echo              Y: Sim
@echo              D: Sim, porem pula o processo de limpeza no proximo boot.
@SET /P COMPACTOS=Aplicar como OS Compacto? (Y, N, or D):
@if %COMPACTOS%.==y. set COMPACTOS=Y
@if %COMPACTOS%.==d. set COMPACTOS=D
@if %COMPACTOS%.==Y. dism /Apply-CustomDataImage /CustomDataImage:W:\Recovery\Customizations\USMT.ppkg /ImagePath:W:\ /SingleInstance
@if %COMPACTOS%.==D. dism /Apply-CustomDataImage /CustomDataImage:W:\Recovery\Customizations\USMT.ppkg /ImagePath:W:\ /SingleInstance /Defer
@echo  *********************************************************************
:HIDEWIMRECOVERYTOOLS
@echo == Escondendo a particao de recuperacao
if %Firmware%==0x1 diskpart /s %~dp0HideRecoveryPartitions-BIOS.txt
if %Firmware%==0x2 diskpart /s %~dp0HideRecoveryPartitions-UEFI.txt
@echo *********************************************************************
@echo == Verificando o status das configuracoes das imagens. ==
W:\Windows\System32\Reagentc /Info /Target W:\Windows
@echo    (Note: Windows RE status may appear as Disabled, this is OK.)
@echo *********************************************************************
@echo      Tudo pronto!
@echo      Disconecte todos os dispositivos USB,
@echo      Digite exit para sair.
@echo.
GOTO END
:CREATEFFURECOVERY
@echo *********************************************************************
@echo == Criando a particao com os pacotes. ==
@if %Firmware%==0x1 diskpart /s CreateRecoveryPartitions-BIOS.txt
@if %Firmware%==0x2 diskpart /s CreateRecoveryPartitions-UEFI.txt
@echo Localizando o drive do Windows
@echo  *********************************************************************
@IF EXIST C:\Windows SET windowsdrive=C:\
@IF EXIST D:\Windows SET windowsdrive=D:\
@IF EXIST E:\Windows SET windowsdrive=E:\
@IF EXIST W:\Windows SET windowsdrive=W:\
@echo O drive do Windows e %windowsdrive%
md R:\Recovery\WindowsRE
@echo  *********************************************************************
@echo Localizando Winre.wim
@IF EXIST %windowsdrive%Recovery\WindowsRE\winre.wim SET recoveryfolder=%windowsdrive%Recovery\WindowsRE\
@IF EXIST %windowsdrive%Windows\System32\Recovery\winre.wim SET recoveryfolder=%windowsdrive%Windows\System32\Recovery\
@echo  *********************************************************************
@echo Copiando Winre.wim
xcopy /h %recoveryfolder%Winre.wim R:\Recovery\WindowsRE\
@echo  *********************************************************************
@echo  == Registrando a localizacao na memoria ==
%windowsdrive%Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target %windowsdrive%Windows
@echo  *********************************************************************
@IF EXIST W:\Recovery\Customizations\USMT.ppkg (GOTO CUSTOMDATAIMAGEFFU) else goto HIDERECOVERYTOOLSFFU
:CUSTOMDATAIMAGEFFU
@echo  == Caso seja OS Compacto, sera provisionaro uma instancia unica com os pacotes de recuperacao ==
@echo.     
@echo     *Nota: Este pacote so ira funcionar caso tenha sido criado o pacote 
@echo      USMT.ppkg dentro do OEM Deployment lab. Caso negativo, escolha N.
@echo.      
@echo     Opcoes:  N: No
@echo              Y: Sim
@echo              D: Sim, porem pula o processo de limpeza no proximo boot.
@SET /P COMPACTOS=Aplicar como OS Compacto? (Y, N, or D):
@if %COMPACTOS%.==y. set COMPACTOS=Y
@if %COMPACTOS%.==d. set COMPACTOS=D
@if %COMPACTOS%.==Y. dism /Apply-CustomDataImage /CustomDataImage:%windowsdrive%Recovery\Customizations\USMT.ppkg /ImagePath:%windowsdrive% /SingleInstance
@if %COMPACTOS%.==D. dism /Apply-CustomDataImage /CustomDataImage:%windowsdrive%Recovery\Customizations\USMT.ppkg /ImagePath:%windowsdrive% /SingleInstance /Defer
:HIDERECOVERYTOOLSFFU
@rem *********************************************************************
@echo == Mascarando as unidades de recuperacao
@if %Firmware%==0x1 diskpart /s HideRecoveryPartitions-BIOS.txt
@if %Firmware%==0x2 diskpart /s HideRecoveryPartitions-UEFI.txt
@echo *********************************************************************
@echo == Verificando o status das imagens . ==
%windowsdrive%Windows\System32\Reagentc /Info /Target %windowsdrive%Windows
@echo    (Nota: Windows pode aparecer como Desabilitado e isto esta OK.)
@echo *********************************************************************
@echo      Tudo pronto!
@echo      Disconecte todos os dispositivos USB.
@echo      Digite exit para sair.
@GOTO END
:END