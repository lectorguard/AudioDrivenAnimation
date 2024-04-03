import os
os.system('pip install yt_dlp')
os.system('pip install spotdl')
import yt_dlp
import spotdl
import sys
import subprocess
import ffmpeg

audio_path = 'audio'
video_path = 'video'

def get_base_name(file_path):
    base_name = os.path.splitext(os.path.basename(file_path))[0]
    return base_name

def download_matching_youtube_vids():
    os.mkdir(video_path)
    os.chdir(video_path)
    for file in os.listdir('../'+audio_path):
        base_name = get_base_name(file)
        query = base_name.replace("_", " ")
        print("Query youtube : " + query)
        ydl_opts = {
            'default_search': 'ytsearch5',  # Limits search to 1 result
            'quiet': True,  # Suppress output
            'outtmpl': f'{base_name}.mp4',  # Output file path with original extension
            'format': 'bestvideo[height<=1080]',  # Limit to HD resolution (720p or 1080p)
        }      
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            result_info = ydl.extract_info(query, download=False)
            # Sort the videos by view count
            sorted_results = sorted(result_info['entries'], key=lambda x: int(x['view_count']), reverse=True)
            # Download the highest viewed video from the sorted list
            highest_viewed_video = sorted_results[0]
            ydl.download([highest_viewed_video['webpage_url']])
    os.chdir('..')

def download_spotify_playlist(url):
    os.mkdir(audio_path)
    os.chdir(audio_path)
    try:
        subprocess.run(["spotdl", url], check=True)
        print("Download spotify songs complete.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
    os.chdir('..')
    

def merge_audio_with_video():
    
    for file in os.listdir(audio_path):
        base_name = get_base_name(file)
        print('audio : ' + f'{audio_path}/{file}')
        print('video : ' + f'{video_path}/{base_name}.mp4')
        
        input_audio = f'"{audio_path}/{file}"'
        input_video = f'"{video_path}/{base_name}.mp4"'
        output_name = f'"{base_name}.mp4"'
        
        try:
            os.system(f'ffmpeg -i {input_video} -i {input_audio} -c:v copy -c:a copy -shortest {output_name}')
            print("Download spotify songs complete.")
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")
    os.chdir('..')
    
    

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python download_video.py <URL> <output_path>")
        sys.exit(1)

    url = sys.argv[1]
    download_spotify_playlist(url)
    download_matching_youtube_vids()
    merge_audio_with_video()
    
