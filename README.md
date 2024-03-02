# Simple Audio Driven Animation


```
Audio (e.g. Limp Bizkit Song)
+
Image (e.g. Jacki Chan Portrait)
```

<img src="Data/LimpBizkit.png" alt="drawing" width="200"/>

```
+ 
Multiple Style Images
```

<img src="Styles/00.png" alt="drawing" width="200"/> <img src="Styles/01.png" alt="drawing" width="200"/> <img src="Styles/02.png" alt="drawing" width="200"/>

```
=
Final Generated Video
```

[![Result](https://img.youtube.com/vi/LsmtZh3U_YY/0.jpg)](https://www.youtube.com/watch?v=LsmtZh3U_YY)


# Prerequisites

- [Scoop Command Line Installer](https://scoop.sh/)

```
// Powershell Installation
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

- [Windows Subsystem for Linux (WSL, Ubuntu)](https://www.microsoft.com/store/productId/9PN20MSR04DW?ocid=pdpshare)

# Running the model

## Prepare data

- Put a `.mp3` file and a `.png` file inside the Data folder, the PNG must be a full body portrait. Use the same file name for both files.
	- If you have multiple tuples of `.mp3` and `.png` files, where each tuple uses the same base name, a video is generated for each tuple
- Put multiple style images (like a VanGogh, space, anime, ...) inside the Style folder
	- Only a random half of the style images is applied to the videos in random order per generated video

## Run the model

- First run FirstRunSadTalker.ps1 by clicking right and selecting run with powershell
	- This will automatically install all dependencies using scoop and pip for the model
	- The model can still work even if errors occur
- Second run SecondRunStyleTransfer.ps1 by clicking right and selecting run with powershell
	- This will automatically install all dependencies using scoop and pip for the model
	- The model can still work even if errors occur
- The result should be placed inside the Result folder

## Thats it

# Troubleshooting

## Wrong Python version is used

Remove all python versions from the environement variable paths. Use scoop instead for all your versions of python, it is better anyway.

## https://discuss.pytorch.org/t/filenotfounderror-could-not-find-module-c10-dll/88422

## Scoop commands fail with internal exception

Type in the last command again by hand into powershell and try multiple times. At some point it installs

## Download of checkpoints/weights aborts with error

Install the model checkpoints by hand (see submodules). Move the files in the correct folder indicated in the error message.
