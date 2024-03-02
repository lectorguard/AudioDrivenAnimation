scoop bucket add versions
scoop install versions/python38
scoop reset python38

scoop install main/ffmpeg

cd SadTalker
# Check if the folder named "checkpoints" does not exist in the current directory
if (-not (Test-Path -Path .\checkpoints -PathType Container)) {
    Write-Host "The folder 'checkpoints' does not exist. Executing downloadCheckpoints.sh..."
    # Execute the shell script using WSL
    wsl ./scripts/download_models.sh
}
pip install -r requirements.txt


# Set the path to the folder containing the PNG files
$folderPath = "..\Data\"

# Get a list of PNG files in the folder
$pngFiles = Get-ChildItem -Path $folderPath -Filter *.png -File

# Iterate over each PNG file and extract the name without the extension
foreach ($file in $pngFiles) {
    $baseName = $file.BaseName
	
	# Full image
    #python inference.py --driven_audio $folderPath$baseName.mp3 `
    #                --source_image $folderPath$baseName.png `
    #                --result_dir ..\Temp `
    #                --still `
    #                --preprocess full `
    #                --enhancer gfpgan 
	
	#portrait mode
	python inference.py --driven_audio $folderPath$baseName.mp3 `
                    --source_image $folderPath$baseName.png `
                    --result_dir ..\Temp `
                    --enhancer gfpgan 
	
	# Rename generated file with base name
	$files = Get-ChildItem -Path ..\Temp -File
	$sortedFiles = $files | Sort-Object -Property CreationTime -Descending
	$lastFile = $sortedFiles[0].FullName
	Write-Host "Rename file old $lastFile new $baseName.mp4"
	Move-Item -Path $lastFile -Destination "..\Temp\$baseName.mp4" -Force
}

Pause

