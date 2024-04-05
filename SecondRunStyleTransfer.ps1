cd style-transfer-video-processor
pip install -r requirements.txt

scoop install versions/cuda11.0

# Must be installed with wsl
wsl pip3 install tensorflow[and-cuda]

#Apply model to app temporary files
$input_folder = "input_videos"

# Get the list of JPG files in the Styles folder
$fileList = Get-ChildItem -Path "..\Styles" -Filter "*.JPG"

# Loop through each file and rename it with the index
for ($i = 0; $i -lt $fileList.Count; $i++) {
    $newName = "{0:D2}.JPG" -f ($i + 1)
    $fileList[$i] | Rename-Item -NewName $newName -Force
}



# Get a list of PNG files in the folder
$mp4Files = Get-ChildItem -Path "..\$input_folder" -Filter *.mp4 -File
$styles = Get-ChildItem -Path ..\Styles -Filter *.JPG -File
foreach ($file in $mp4Files) {
	$baseName = $file.baseName
	
	$sequence = 0..($styles.Count-1)
	$shuffledSequence = $sequence | Get-Random -Count $sequence.Count
	$shuffledSequence = $shuffledSequence[0..(($shuffledSequence.Count-1)/2)]
	$finalSequence = $shuffledSequence -join ','

	
	$configString = @"
# Brycen Westgarth and Tristan Jogminas
# March 5, 2021

class Config:
    ROOT_PATH = "."
    # defines the maximum height dimension in pixels. Used for down-sampling the video frames
    FRAME_HEIGHT = 360
    CLEAR_INPUT_FRAME_CACHE = True
    # defines the rate at which you want to capture frames from the input video
    INPUT_FPS = 20
    INPUT_VIDEO_NAME = "../$input_folder/$baseName.mp4"
    INPUT_VIDEO_PATH = f'{ROOT_PATH}/{INPUT_VIDEO_NAME}'
    INPUT_FRAME_DIRECTORY = f'{ROOT_PATH}/input_frames'
    INPUT_FRAME_FILE = '{:0>4d}_frame.png'
    INPUT_FRAME_PATH = f'{INPUT_FRAME_DIRECTORY}/{INPUT_FRAME_FILE}'

    STYLE_REF_DIRECTORY = "../Styles"
    # defines the reference style image transition sequence. Values correspond to indices in STYLE_REF_DIRECTORY
    # add None in the sequence to NOT apply style transfer for part of the video (ie. [None, 0, 1, 2])  
    STYLE_SEQUENCE = [$finalSequence]

    OUTPUT_FPS = 20
    OUTPUT_VIDEO_NAME = "../Result/temp_$baseName.mp4"
    OUTPUT_VIDEO_PATH = f'{ROOT_PATH}/{OUTPUT_VIDEO_NAME}'
    OUTPUT_FRAME_DIRECTORY = f'{ROOT_PATH}/output_frames'
    OUTPUT_FRAME_FILE = '{:0>4d}_frame.png'
    OUTPUT_FRAME_PATH = f'{OUTPUT_FRAME_DIRECTORY}/{OUTPUT_FRAME_FILE}'

    GHOST_FRAME_TRANSPARENCY = 0.1
    PRESERVE_COLORS = True
    TENSORFLOW_CACHE_DIRECTORY = f'{ROOT_PATH}/tensorflow_cache'
    TENSORFLOW_HUB_HANDLE = 'https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2'
"@
	Set-Content -Path config.py -Value $configString
	
	$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
	Write-Host "$timestamp Start converting video $baseName"
	python3 style_frames.py
	$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
	Write-Host "$timestamp Done."
	
	Write-Host "Copy audio from temp video to result video"
	if (Test-Path ../Result/$baseName.mp4) {
		Remove-Item ../Result/$baseName.mp4 -Force
	}
	ffmpeg -i ../Result/temp_$baseName.mp4 -i ../$input_folder/$baseName.mp4  -c copy -map 0:v -map 1:a ../Result/$baseName.mp4
	Remove-Item -Path "../Result/temp_$baseName.mp4"
}
Pause
