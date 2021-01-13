# gclone
gclone with time interval for sync 


How to run 

docker run -it --rm -e TZ=\<timezone\> -e to_path="\<remotename\>:\<location where to upload\>" -e from_path="\<contain mount path for file upload\>" -e intvl=\<time interval\>  -v \<rclone path\>:/var/gclone/.config/rclone -v \<local machine file path\>:\<contain mount path for file upload\> poornatheju/gclone



Eg: 
docker run -it --rm -e TZ=Asia/Calcutta -e to_path="gdrive_team:/poorna/" -e from_path="/tmp/poorna" -e intvl=15  -v /gclone_docker/config/rclone:/var/gclone/.config/rclone -v /mnt/videos:/tmp/poorna poornatheju/gclone


note intvl is in min


rclone.conf sample 


[gdrive_team]
type = drive
scope = drive
service_account_file = /var/gclone/.config/rclone/accounts/xyz.json
service_account_file_path = /var/gclone/.config/rclone/accounts
team_drive = asdasf
