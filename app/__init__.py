from flask import Flask
from pymongo import MongoClient 
import os
client = MongoClient('mongodb://localhost:27017/',connect=False)
db = client['store']

app = Flask(__name__, static_url_path='/static') #instance of a Flask class, uses __name__ since we're using a single module

app.config['TEMPLATES_AUTO_RELOAD'] = True #Helps with debug of frontend
app.config['SECRET_KEY'] = os.urandom(20).hex() #secret for the app, used for authentication of sessions

from app import routes
