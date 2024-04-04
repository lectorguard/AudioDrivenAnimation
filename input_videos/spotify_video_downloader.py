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
            if 'entries' in result_info and len(result_info['entries']) > 0:
                # Check if any video title contains a portion of the found query title
                song_name = query.split("-")[-1].strip().lower()
                print('Song name ' + song_name)
                contains_title = [entry for entry in result_info['entries'] if song_name in entry['title'].lower()]
                contains_title_and_video = [entry for entry in result_info['entries'] if song_name in entry['title'].lower() and 'video' in entry['title'].lower()]
                contains_title_and_live = [entry for entry in result_info['entries'] if song_name in entry['title'].lower() and 'live' in entry['title'].lower()]
                queries = [contains_title_and_video, contains_title_and_live, contains_title, result_info['entries']]
                for elem in queries:
                    if elem:
                        sorted_results = sorted(elem, key=lambda x: int(x['view_count']), reverse=True)
                        highest_viewed_video = sorted_results[0]
                        print('Download title' + highest_viewed_video['title'])
                        ydl.download([highest_viewed_video['webpage_url']])
                        break
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
    if len(sys.argv) == 2:
        url = sys.argv[1]
        download_spotify_playlist(url)
    download_matching_youtube_vids()
    merge_audio_with_video()
    
