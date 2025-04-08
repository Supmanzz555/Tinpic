from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from pymongo import MongoClient
import os
from pathlib import Path
from datetime import datetime


app = FastAPI()

# Mongo connect
client = MongoClient("mongodb://localhost:27017")
db = client['tinpic']
collection = db['images']

# path for storing the pics  (stay besides main.py)
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
Path(UPLOAD_DIR).mkdir(parents=True, exist_ok=True)

app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# gen ID (1 2 3 ... )
def generate_id():
    last_id = collection.find_one(sort=[('ID', -1)])
    return last_id['ID'] + 1 if last_id else 1

# upload
@app.post("/upload")
async def upload_image(file: UploadFile = File(...)):
    image_id = generate_id()
    file_location = os.path.join(UPLOAD_DIR, f"{image_id}_{file.filename}")
    
    with open(file_location, "wb") as f:
        f.write(file.file.read())
    
    # metadata
    image_data = {
        'ID': image_id,
        'name': file.filename,
        'path': f"uploads/{image_id}_{file.filename}",  # path to upload folder
        'upload_date': datetime.utcnow()  
    }
    collection.insert_one(image_data)

    return JSONResponse(content={"message": "Upload successful", "image_id": image_id}, status_code=200)

# Fetch 
@app.get("/photos")
async def get_images():
    try:
        images = list(collection.find({}, {'_id': 0}))
        
        # format date to string
        for image in images:
            if "upload_date" in image:
                image["upload_date"] = image["upload_date"].isoformat()  
        
        return JSONResponse(content=images)
    
    except Exception as e:
        return JSONResponse(content={"message": f"Error fetching images: {str(e)}"}, status_code=500)

# delate
@app.delete("/images/{image_id}")
async def delete_image(image_id: int):
    image = collection.find_one({"ID": image_id})
    if image:
        file_path = image['path']
        if os.path.exists(file_path):
            os.remove(file_path)
        collection.delete_one({"ID": image_id})
        return JSONResponse(content={"message": "Image deleted successfully!"}, status_code=200)
    return JSONResponse(content={"message": "Image not found!"}, status_code=404)
