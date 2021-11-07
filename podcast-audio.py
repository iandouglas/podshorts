from pathlib import Path
import textwrap
from datetime import datetime
import os
import sys
from PIL import Image, ImageDraw, ImageFont


def extract_audio(input_video_filename, start_time, end_time):
    # audio/video clip duration
    fmt = '%Y-%m-%d %H:%M:%S'
    tstamp1 = datetime.strptime(f'2021-08-30 {start_time}', fmt)
    tstamp2 = datetime.strptime(f'2021-08-30 {end_time}', fmt)
    td = tstamp2 - tstamp1
    duration = int(td.total_seconds())

    tmp_filename = input_video_filename.replace('.mp4', f'.{start_time}.mp4').replace(':','')
    output_audio_filename = tmp_filename.replace('.mp4', '.mp3')

    # trim out the tmp video fragment
    cmd = f'ffmpeg -y -i {input_video_filename} -ss {start_time} -t {duration} -async 1 -v quiet {tmp_filename}'
    print(cmd)
    os.system(cmd)
    
    # extract audio from tmp video
    cmd = f'ffmpeg -y -i {tmp_filename} -b:a 192K -vn -v quiet {output_audio_filename}'
    print(cmd)
    os.system(cmd)

    os.remove(f'./{tmp_filename}')

    return {
        'duration': duration,
        'filename': output_audio_filename,
    }


def make_intro(payload):
    input_file = payload['filename']
    teaser_filename = input_file.replace('.mp3', '.teaser.mp3')
    louder_filename = teaser_filename.replace('.teaser', '.louder')
    merged_filename = louder_filename.replace('.louder', '.merged')

    # bump up the volume a bit
    cmd = f'ffmpeg -y -i {input_file} -filter:a "volume=1.6" -v quiet {louder_filename}'
    print(cmd)
    os.system(cmd)

    # combine audio for intro
    files_to_mege = 4
    cmd = f'ffmpeg -y -i podcast-2sec-silence.mp3 -i {louder_filename} -i podcast-intro.mp3 -i podcast-3sec-silence.mp3 -filter_complex [0:a][1:a]concat=n={files_to_mege}:v=0:a=1 -v quiet {teaser_filename}'
    print(cmd)
    os.system(cmd)
    
    # bump up the volume a bit
    cmd = f'ffmpeg -y -i {teaser_filename} -filter:a "volume=1.5" -v quiet {louder_filename}'
    print(cmd)
    os.system(cmd)
    
    # merge audio intro with music
    cmd = f'ffmpeg -y -i {louder_filename} -i podcast-music-quieter.mp3 -filter_complex amix=inputs=2:duration=shortest -v quiet {merged_filename}'
    print(cmd)
    os.system(cmd)
    
    # get duration
    cmd = f'ffprobe -i {merged_filename} -show_entries format=duration -v quiet -of csv="p=0"'
    print(cmd)
    duration = int(round(float(os.popen(cmd).read()), 0))
    print(cmd)
    print('duration', duration)
    
    # add fade out
    fade_time = 3
    cmd =f'sox {merged_filename} {teaser_filename} fade t 0 0 {fade_time}'
    print(cmd)
    os.system(cmd)

    cmd = f'ffmpeg -y -i {teaser_filename} -filter:a "volume=2.4" -v quiet {teaser_filename}_tmp'
    print(cmd)
    os.system(cmd)
    cmd = f'mv {teaser_filename}_tmp {teaser_filename}'
    print(cmd)
    os.system(cmd)

    # remove temp files
    os.remove(f'./{input_file}')
    os.remove(f'./{louder_filename}')
    os.remove(f'./{merged_filename}')

    return {
        'duration': duration,
        'filename': teaser_filename,
    }

def make_podcast(intro_payload, episode_payload, title):
    intro_filename = intro_payload['filename']
    episode_filename = episode_payload['filename']
    podcast_filename = episode_filename.replace('.mp3', '.final-podcast.mp3')

    # combine teaser, episode, and outtro
    files_to_merge = 3
    cmd = f'ffmpeg -y -i {intro_filename} -i {episode_filename} -i podcast-outro.mp3 -filter_complex [0:a][1:a]concat=n={files_to_merge}:v=0:a=1 -v quiet {podcast_filename}'
    print(cmd)
    os.system(cmd)
    
    podcast_title = podcast_filename.replace('.mp3','.txt')
    with open(f'{podcast_title}', 'w') as f:
        f.write(f"{title}\n")

    # remove temp files
    os.remove(f'./{intro_filename}')
    os.remove(f'./{episode_filename}')

    return {
        'filename': podcast_filename,
    }



data = None
with open('podcast-audio.txt', 'r') as f:
    data = f.read().split("\n")

for row in data:
    if len(row) > 1:
        if row[0] == '#':
            continue
        bits = row.split('|')

        if bits[0] == 'stop':
            sys.exit()
        if len(bits) != 7:
            print('error in line, need 7 fields')
            print(bits)
            continue

        print('-'*100)
        episode_file = bits[0]
        episode_start = bits[1]
        episode_end = bits[2]

        teaser_file = bits[3]
        teaser_start = bits[4]
        teaser_end = bits[5]

        title = bits[6]

        if not Path(episode_file).is_file():
            print(f'{episode_file} not found')
            continue
        if not Path(teaser_file).is_file():
            print(f'{teaser_file} not found')
            continue

        episode = extract_audio(episode_file, episode_start, episode_end)
        print(episode)
        teaser = extract_audio(teaser_file, teaser_start, teaser_end)
        print(teaser)
        intro = make_intro(teaser)
        print(intro)
        res = make_podcast(intro, episode, title)
        print(res)

