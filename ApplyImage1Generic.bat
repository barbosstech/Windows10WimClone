@rem == ###### PETRORIO SA ######
@rem    Script de clone de imagens .wim para Windows 10 2H21.
@rem    Por Carlos Eduardo Barbosa - Julho/21 v1.0

@rem == Definindo performance para nVME ==
call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

@rem == Aplicando a imagem para a partição do Windows... ==
dism /Apply-Image /ImageFile:"E:\Imagens\PRIOSysPrep.wim" /Index:1 /ApplyDir:W:\

@rem == Copiando arquivos de boot para a particao do Sistema ==
W:\Windows\System32\bcdboot W:\Windows /s S:

:rem == Copy the Windows RE image to the
:rem    Windows RE Tools partition ==
md R:\Recovery\WindowsRE
xcopy /h E:\Imagens\PRIOSysPrep.wim R:\Recovery\WindowsRE\

:rem == Register the location of the recovery tools ==
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows

:rem == Verify the configuration status of the images. ==
W:\Windows\System32\Reagentc /Info /Target W:\Windows