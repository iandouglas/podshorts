from pathlib import Path
import textwrap
from datetime import datetime
import os
from PIL import Image, ImageDraw, ImageFont


data = None
with open('video-split.txt', 'r') as f:
    data = f.read().split("\n")

for row in data:
    if len(row) > 1:
        if row[0] == '#':
            continue
        bits = row.split('|')

        origin_file = bits[0]
        if not Path(bits[0]).is_file():
            print(f'{bits[0]} not found')
            continue
        dest_file = origin_file.replace('.mp4', '.marker.mp4')

        do_thumbnail = True

        if len(bits) >= 4:
            print('-'*100)
            thumbnail_base = Image.open('./qa-thumbnail-background.png')
            # font = ImageFont.truetype('./UbuntuCondensed-Regular.ttf', 125, encoding='unic')
            font = ImageFont.truetype('./Lato-BlackItalic.ttf', 100, encoding='unic')

            start_time = bits[1]
            end_time = bits[2]
            title = bits[3]

            merge_videos = True
            if title[0] == '*':
                merge_videos = False
                title = title[1:]

            fmt = '%Y-%m-%d %H:%M:%S'
            tstamp1 = datetime.strptime(f'2021-08-30 {start_time}', fmt)
            tstamp2 = datetime.strptime(f'2021-08-30 {end_time}', fmt)
            td = tstamp2 - tstamp1
            duration = int(td.total_seconds())

            tmp_file = dest_file.replace('.marker', f'.tmp.{start_time}').replace(':','')
            output_file = dest_file.replace('.marker', f'.{start_time}').replace(':','')
            intro_file = 'youtube-qa-intro.mp4'
            outro_file = 'youtube-qa-outro.mp4'

            print(f'{start_time}, {end_time}, {duration}, {tmp_file}')

            # trim out the tmp video fragment
            cmd = f'ffmpeg -y -i {origin_file} -ss {start_time} -t {duration} -async 1 -v quiet {tmp_file}'
            print(cmd)
            os.system(cmd)

            # concat together with intro/outro
            if merge_videos:
                cmd = f' ffmpeg -y -i {intro_file} -i {tmp_file} -i {outro_file} -filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] concat=n=3:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" -v quiet {output_file}'
                print(cmd)
                os.system(cmd)

            wrapped_title = textwrap.wrap(title, width=25)

            # with open(f'{output_file}.txt', 'w') as f:
            #    f.write(f"{title}\n")

            if do_thumbnail:
                line_ys = []
                avg_line_height = 0
                for line in wrapped_title:
                    font_width, font_height = font.getsize(line)
                    if font_width > 1280:
                        print(line, '<--- is too long!!!!!', font_width)
                    avg_line_height += font_height
                avg_line_height //= len(wrapped_title)
                avg_line_height += 8

                lines = len(wrapped_title)
                mid_point_x = 640
                mid_point_y = 300
                if len(wrapped_title) == 1:
                    line_ys = [ mid_point_y - int(avg_line_height/2) ]
                if len(wrapped_title) == 2:
                    line_ys = [
                        mid_point_y - avg_line_height, 
                        mid_point_y
                        ]
                elif len(wrapped_title) == 3:
                    line_ys = [
                        mid_point_y - int(avg_line_height*1.5), 
                        mid_point_y - int(avg_line_height/2), 
                        mid_point_y + int(avg_line_height/2)
                        ]

                # print(wrapped_title, avg_line_height, line_ys)
                draw = thumbnail_base.copy()
                img_copy = ImageDraw.Draw(draw)
                for idx, line in enumerate(wrapped_title):
                    font_width, font_height = font.getsize(line)
                    
                    # outline
                    img_copy.text(((mid_point_x - int(font_width/2))-2, line_ys[idx]-2), line, font=font, fill='black')
                    img_copy.text(((mid_point_x - int(font_width/2))-2, line_ys[idx]+2), line, font=font, fill='black')
                    img_copy.text(((mid_point_x - int(font_width/2))+2, line_ys[idx]-2), line, font=font, fill='black')
                    img_copy.text(((mid_point_x - int(font_width/2))+2, line_ys[idx]+2), line, font=font, fill='black')

                    # text
                    img_copy.text((mid_point_x - int(font_width/2), line_ys[idx]), line, font=font, fill=(1, 170, 254))

                if Path(f'{output_file}.png').is_file():
                    os.remove(f'{output_file}.png')
                draw.save(f'{output_file}.png')

            if (not do_thumbnail or merge_videos) and Path(f'./{tmp_file}').is_file():
                os.remove(f'./{tmp_file}')

            if title == 'q':
                import sys; sys.exit()
