@echo Find a drive that has a folder titled Images.
@for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do @if exist %%a:\Imagens\ set IMAGESDRIVE=%%a
@echo The Images folder is on drive: %IMAGESDRIVE%
@dir %IMAGESDRIVE%:\Imagens /w