import cv2
import os
from moviepy.editor import VideoFileClip
import subprocess
import shutil

def processVideo(path,videoname):
    try:
        # Run YOLO object detection
        receive_path = os.path.join(path,"Received_Videos")
        result = subprocess.run(['yolo', 'detect', 'predict', 'model=yolov8s.pt', 'source="' + receive_path +'/'+videoname+'"', 'project="' +path+ '"'], capture_output=True, text=True)

        if result.returncode != 0:
            # YOLO command failed, print error and command output
            print("YOLO command execution failed with error:")
            return 500
        else:
            # YOLO command succeeded, continue with video conversion
            newPath = os.path.join(path,"predict")
            input_video_path = os.path.join(newPath, videoname.rsplit('.', 1)[0] + '.avi')
            output_video_path = os.path.join(path, 'final.mp4')
            # Convert the processed video to .mp4
            clip = VideoFileClip(input_video_path)
            clip.write_videofile(output_video_path, codec='libx264', audio_codec='aac', preset='slow', bitrate='5000k')
            print("Video processing completed successfully!")
            try:
                shutil.rmtree(newPath)
                print(f"Folder '{newPath}' and its contents successfully deleted.")
            except OSError as e:
                print(f"Error: {newPath} : {e.strerror}")
            # DELETE THE VIDEOS AND DIRECTORIES LATER
            # SEND THE VIDEO TO THE FRONTEND
            return 200
    except Exception as e:
        return 500

def process(path,videoname):
    try:
        # Construct path to the video
        
        # path = os.path.join("/static/", username + "/")

        # Call processVideo
        return processVideo(path,videoname)
    except Exception as e:
        print("Enception occured")
