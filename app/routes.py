from app import app,db
from flask import render_template, request, redirect
import yagmail

@app.route('/')
def home():
    people = db['people'].find({})
    return render_template('home.html', people=people)

@app.route('/edit', methods=['GET','POST'])
def edit():
    if request.method == 'GET':
        return render_template('edit.html')
    else:

        if db['people'].find_one({'name':request.form['name']}) == None:
            db['people'].insert_one({'name':request.form['name'],'color':request.form['color']})
        else:
            db['people'].update_one({'name':request.form['name']},{'$set':{'color':request.form['color']}})

        for email in  ['scutler3@u.rochester.edu','kbenning@u.rochester.edu','sturn20@u.rochester.edu','ccummins@u.rochester.edu']:
            yag = yagmail.SMTP('hello@joinaura.us','AURAtest!@#')
            yag.send(to=email, subject="Someone's color changed", contents=f"{request.form['name']} is now on {request.form['color']}")
        
        return redirect('/')
