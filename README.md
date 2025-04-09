# Tinpic, your unusual photo managing App
Tired of going through your phone's pictures and selecting each one individually to remove them? Or maybe you're looking for more entertaining ways to do it? GOOD NEWS! This app is designed for you!

  

> This app built using flutter / MongoDB / FastAPI to connect front and back

![Maybe you can get the idea of my app now XD](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3lrdGE4cHkwcHNjcW03ZTBvaGFmaGFweXZtZDV6eGRuZWkxNWIwNCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/26mkhMYkitO7DoJuU/giphy.gif)

## Note
To be honest, I'm only coding this to practice my flutter and backend skills, but this app is open source, so you can literally download my code to improve it or play with it whenever you want!

> About 90 percent of the app is working as intended. UI/UX appears to be off (I'm not that good at this XD). considering this is a very early alpha version.


# Feature

 - **Tinder-like Swiping**:
	 - wipe **left** to delete photos or **right** to keep them, just like dating app!
- **Cloud Storage**:
	- This is my personal concept to implement as we need to upload pictures to clouds then you can start to swipe (maybe I will try adding local photos as well).
- **Selecting time before swiping**:
	- The app will automatically sort your photos by date (month and year), and there is a random feature that, as stated, randomly selects all of your pictures in the database.


## How to Run the App Locally (backend)
followed these step:
### 1.clone this repo

	git clone https://github.com/Supmanzz555/Tinpic.git
	cd Tinpic
	
### 2. Settings up backend
-	**Install Dependencies**:

	~~~
    cd FastAPi_mongo
    pip install -r requirements.txt
-	**Start MongoDB**:
	-	Make sure you have **MongoDB** installed and running on your machine. If you don’t have it, [install MongoDB](https://www.mongodb.com/try/download/community) and start it.

-	**Run the FastAPI Backend**:

    uvicorn main:app --reload
	
	-	You can test if backend is running by enter this URL`http://localhost:8000/docs`



# 🧑‍🤝‍🧑 Contributing
Yes and feels free to do it 




