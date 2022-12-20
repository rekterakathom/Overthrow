:: Cleanup old .sqfc
python sqfc_cleanup.py

:: Build new .sqfc
ArmaScriptCompiler.exe

:: HEMTT packing
cd Overthrow
start /wait "" "C:\Program Files (x86)\HEMTT\bin\hemtt.exe" build --release

:: Cleanup .sqfc as it is not needed after being packed
python sqfc_cleanup.py