from flask import Flask, request, send_file
import os
from my_yolov8s import process
app = Flask(__name__)

UPLOAD_FOLDER = 'C:/Users/SAM/Documents/App develop/Backend'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/receive-video', methods=['POST'])
def receive_video():
    if 'video' not in request.files:
        return 'No video file provided', 400

    video_file = request.files['video']
    username = request.args.get("username")
    print(username)
    if video_file.filename == '':
        return 'No selected file', 400

    USER_FOLDER = os.path.join(UPLOAD_FOLDER,username)
    RECEIVE_FOLDER = os.path.join(USER_FOLDER,"Received_Videos")
    print(RECEIVE_FOLDER)
    if not os.path.exists(RECEIVE_FOLDER):
        os.makedirs(RECEIVE_FOLDER)
    video_path = os.path.join(RECEIVE_FOLDER, video_file.filename)
    video_file.save(video_path)

    # Process the video
    processed_video = process(USER_FOLDER,video_file.filename)
    
    # Check if processing succeeded
    if processed_video is None:
        return 'Error processing video', 500

    return 'Video received and processed successfully', 200

@app.route('/send-video', methods=['POST'])
def send_video():
    username = request.args.get("username")
    USER_FOLDER = os.path.join(UPLOAD_FOLDER,username)
    processed_video_files = os.listdir(USER_FOLDER)
    if not processed_video_files:
        return 'No processed video available', 404

    # Assuming there is only one processed video file, you can modify this part accordingly
    processed_video_filename = "final.mp4"
    processed_video_path = os.path.join(USER_FOLDER, processed_video_filename)

    return send_file(processed_video_path, as_attachment=True)

@app.route('/delete-video', methods=['POST'])
def delete_video():
    username = request.args.get("username")
    USER_FOLDER = os.path.join(UPLOAD_FOLDER,username)
    processed_video_files = os.listdir(USER_FOLDER)
    if not processed_video_files:
        return 'No processed video available', 404

    # Assuming there is only one processed video file, you can modify this part accordingly
    processed_video_filename = "final.mp4"
    processed_video_path = os.path.join(USER_FOLDER, processed_video_filename)
    os.remove(processed_video_path)
    return 'Final file removed', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
