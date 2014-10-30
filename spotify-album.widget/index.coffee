command: """
read -r running <<<"$(ps -ef | grep \"MacOS/Spotify\" | grep -v \"grep\" | wc -l)" &&
test $running != 0 &&
IFS='|' read -r theArtist theName <<<"$(osascript <<<'
    tell application "Spotify"
      set theTrack to current track
      set theArtist to artist of theTrack
      set theName to name of theTrack
      set theArtwork to artwork of theTrack
      set currentArtworkFile to ((path to home folder) as text) & "Library:Application Support:Übersicht:widgets:spotify-album.widget:album.tiff"
      set updatedArtworkFile to ((path to home folder) as text) & "Library:Application Support:Übersicht:widgets:spotify-album.widget:album-new.tiff"
      set currentArtworkFileUnix to the quoted form of POSIX path of currentArtworkFile
      set updatedArtworkFileUnix to the quoted form of POSIX path of updatedArtworkFile

      set fileRef to (open for access updatedArtworkFile with write permission)
      try
        write theArtwork to fileRef
        close access fileRef
      on error errorMsg
        try
          close access fileRef
        end try
      end try

      do shell script "mv " & updatedArtworkFileUnix & space & currentArtworkFileUnix

      return theArtist & "|" & theName
    end tell')" &&
echo "$theArtist <br/> $theName" || echo "Not Connected To Spotify"
"""

refreshFrequency: 5000

style: """
  bottom: 20px
  right: 10px
  color: #fff

  .album-art
    border: 2px white solid
    border-radius: 2px
    transform: rotate(5deg)
    margin-bottom: 10px
    margin-left: 20px

  .currently-playing
    font-family: Helvetica Neue
    font-size: 15px
    font-weight: 200
    text-shadow: 0 1px 5px #000000;
"""

render: (output) -> """
  <img width="100px" height="100px" class="album-art" src="spotify-album.widget/album.tiff"></img>
  <div class="currently-playing">#{output}</div>
"""
