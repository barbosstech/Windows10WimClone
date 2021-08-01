# Windows10WimClone
This repository is intendend to bring together all files and batches I've made to create WinPE flash, capture .wim and deploy formatting the destination device. It can be deployed from Windows to Windows and Linux to Windows.
Used tools: a flash drive with > 8GB and a external disk to serve as local repository > 500GB

Creation process is on file Preparando o ambiente (Server de laboratório)

Criando o WinPE
1. Instalar adkwinpesetup (1.556kb)
2. Reiniciar
3. Buscar por "CMD Ambiente de Ferramentas de Implantação de Geração de Imagens"
4. copype amd64 C:\WinPE_amd64
5. MakeWinPEMedia /UFD C:\WinPE_amd64 E: (unidade flash)
6. Também pode ser feito através de algum burner de .iso para flash (Imagem .iso attachada)


Sysprep
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation

1. %WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe

Capturando a imagem .wim
1. Attachar o HD externo
2. F12 Boot pelo WinPE
3. Dism /Capture-Image /ImageFile:"E:\Imagens\Nome.wim" /CaptureDir:C:\ /Name:Descricao
	(Onde E:\ é a unidade flash ou outro storage)
4. Aguardar finalizar.
5. Remover o HD (ou storage), o flashdisk
6. Exit

Aplicando a imagem
1. Atualizar a BIOS e Chipset. (testar nos novos antes de atualizar)
2. Attachar o HD externo
3. F12 Boot pelo WinPE
4. D:\ para acessar os scripts
5. Executar script "LimparDisco.bat"
6. Executar o script "Clonar.bat"
7. Escolher o modelo
8. Recuperar particao? Y
9. OS Compacto?  Y
10. Atrrib estendidos: N
11. Exit
12. Religar o wi-fi
13. Renomear e colocar no domínio
14. Em caso de falha utilizar o script "Recuperar.bat" e recomeçar.

> Diskpart
>> List disk


Incrementar Menu .bat
https://www.sevenforums.com/tutorials/78083-batch-files-create-menu-execute-commands.html

PXE
https://docs.microsoft.com/pt-br/windows/deployment/configure-a-pxe-server-to-load-windows-pe


Fonte:
CMD Builder: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/system-builder-deployment-of-windows-10-for-desktop-editions

Criação do flash WINPE: https://docs.microsoft.com/pt-br/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive

Capturar e aplicar a imagem . wim https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim

Scripts: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-deployment-sample-scripts-sxs#keeping-windows-settings-through-a-recovery

Customizações: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-deployment-sample-scripts-sxs#CreatePartitions-_firmware_.txt

https://www.youtube.com/watch?v=7ycFW19IUNI&ab_channel=TechDeskVlogs
