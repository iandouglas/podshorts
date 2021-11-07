# PodShorts

Application to allow a streamer to set a local filename of an MP4 video, mark start/stop end times, and automatically produce YouTube-friendly "shorts" videos in MP4 format, including an intro/outro, and also to export audio clips into MP3 clips suitable for podcast software.

## Build

* Rails 6, Ruby 2.7
* PostgreSQL
* RSpec testing
* Python 3.7+
* ffmpeg

## Features

- general setup screen
  - podcast intro/outro mp3 filename
  - youtube intro/outro mp4 filename
  - future plans for uploading on my behalf:
    - set YouTube API key
    - set podbean API key

- full CRUD
  - add a clip (done)
    - add main video filename
    - add start/end times from main video

    - checkboxes whether that clip is for podcast
      - add publication date
      - podcast title, description
      - podcast filename for intro clip, start/end time

    - checkboxes whether that clip is for youtube
      - add publication date
      - youtube title, description
        - title has a hard size limit for thumbnail generation
      - thumbnail string

  - index page (done)
  - show/edit (done)
  - delete action (done)

## database setup

`rails db:create`

- table: clips
  - id: int
  - is_finished, boolean
  - is_published, boolean
  - video_filename, string
  - clip_starttime, time
  - clip_endtime, time
  - is_podcast, boolean
  - podcast_pub_datetime, datetime
  - podcast_title, string
  - podcast_desc, text
  - podcast_teaser_file, string
  - podcast_teaser_starttime, time
  - podcast_teaser_endtime, time
  - is_youtube, boolean
  - youtube_pub_datetime, datetime
  - youtube_title, string
  - youtube_desc, text
  - youtube_thumbnail_text, string

