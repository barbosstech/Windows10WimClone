cls
@echo *********************************************************************
@echo.
@echo 	###### PETRORIO SA ######
@echo.
@echo	MANTENHA O COMPUTADOR CONECTADO NA FONTE!
@echo	Script de clone de imagem .wim para Windows 10 2H21.
@echo	Por Carlos Eduardo Barbosa - Julho/21 v1.0
@echo.
@echo *********************************************************************
@echo.
@if not exist X:\Windows\System32 echo ERROR: This script is built to run in Windows PE.
@if not exist X:\Windows\System32 goto END
@if %1.==. echo ERROR: To run this script, add a path to a Windows image file.
@if %1.==. echo Example: ApplyImage E:\Imagens\Contoso.wim
@if %1.==. goto END
@echo *********************************************************************
@echo  == Pre set das configuracoes de alta performance - MANTENHA O COMPUTADOR NA ENERGIA ==
@call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
@echo *********************************************************************
@echo Verificando o caminho apontado da imagem .wim
@if "%~x1" == "D:\Imagens\PRIOLatitude3410.wim" (GOTO WIM)
@if "%~x1" == "E:\Imagens\PRIOLatitude3410.wim" (GOTO WIM)
@if "%~x1" == "F:\Imagens\PRIOLatitude3410.wim" (GOTO WIM)
@if "%~x1" == ".ffu" (GOTO FFU)
@echo *********************************************************************
@if not "%~x1" == ".ffu". if not "%~x1" == ".wim" echo Please use this script with a WIM or FFU image.
@if not "%~x1" == ".ffu". if not "%~x1" == ".wim" GOTO END
:WIM
@echo Iniciando o processo de copia da imagem .WIM
@echo *********************************************************************
@echo Verificando se o PC foi inicializado em modo BIOS ou UEFI.
wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%B
@echo            Note: delims is a TAB followed by a space.
@if x%Firmware%==x echo ERROR: Can't figure out which firmware we're on.
@if x%Firmware%==x echo        Common fix: In the command above:
@if x%Firmware%==x echo             for /f "tokens=2* delims=	"
@if x%Firmware%==x echo        ...replace the spaces with a TAB character followed by a space.
@if x%Firmware%==x goto END
@if %Firmware%==0x1 echo The PC is booted in BIOS mode. 
@if %Firmware%==0x2 echo The PC is booted in UEFI mode. 
@echo *********************************************************************
@echo Criar a particao de Recuperacao?
@echo    (Se estiver trabalhando com particoes FFUs, e precisar 
@echo     expandir a particao apos o clone digite N). 
@SET /P RECOVERY=(Y or N):
@if %RECOVERY%.==y. set RECOVERY=Y
@echo Formatando o disco primario...
@if %Firmware%==0x1 echo    ...using BIOS (MBR) format and partitions.
@if %Firmware%==0x2 echo    ...using UEFI (GPT) format and partitions. 
@echo ATENCAO: Todas as informacoes serao EXCLUIDAS.
@SET /P READY=Prosseguir? (Y or N):
@if %READY%.==y. set READY=Y
@if not %READY%.==Y. goto END
@if %Firmware%.==0x1. if %RECOVERY%.==Y. diskpart /s CreatePartitions-BIOS.txt
@if %Firmware%.==0x1. if not %RECOVERY%.==Y. diskpart /s CreatePartitions-BIOS-FFU.txt
@if %Firmware%.==0x2. if %RECOVERY%.==Y. diskpart /s CreatePartitions-UEFI.txt
@if %Firmware%.==0x2. if not %RECOVERY%.==Y. diskpart /s CreatePartitions-UEFI-FFU.txt
@echo *********************************************************************
@echo  == Injetando a imagem na particao do Windows ==
@SET /P COMPACTOS=Aplicar Windows 10 2H21? (Y or N):
@if %COMPACTOS%.==y. set COMPACTOS=Y
@echo Esta imagem contem particoes estendidas?
@echo    (If you're not sure, type N).
@SET /P EA=(Y or N):
@if %EA%.==y. set EA=Y
@if %COMPACTOS%.==Y.     if %EA%.==Y.     dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\ /Compact /EA
@if not %COMPACTOS%.==Y. if %EA%.==Y.     dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\ /EA
@if %COMPACTOS%.==Y.     if not %EA%.==Y. dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\ /Compact
@if not %COMPACTOS%.==Y. if not %EA%.==Y. dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\
@echo *********************************************************************
@echo == Injetando os arquivos finais da instalacao ==
W:\Windows\System32\bcdboot W:\Windows /s S:
@echo *********************************************************************
@echo   Clone realizado com sucesso
@echo   * Remova os dispositivos USB
@echo      e digite exit
@GOTO END
:END
