from flask import Flask, render_template, request, flash
from marketvaluemodule import midfield_player, goalkeep_player, defend_player, attacking_player, model_score
import os

path = os.getcwd()

os.chdir("/Users/ayman/OneDrive/Documents/GitHub/Market-Value-Predictor")

app = Flask(__name__)
app.secret_key = "your_secret_key"

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/accuracy')
def accuracy():
    accuracy = model_score()
    accuracy = int(accuracy * 100)
    result = f"Accuracy of our model is {accuracy}%"
    return render_template('index.html', result=result)

@app.route('/', methods=['POST'])
def get_value():
    if request.form.get('reset') == 'Reset':
        return render_template('index.html')
    elif request.form.get('accuracy') == 'Accuracy':
        return redirect(url_for('accuracy'))
    else:
        player_name = request.form['player_name']
        position = request.form['position']
        try:
            if position == "Attacker":
                market_value = attacking_player(player_name)
            elif position == "Midfielder":
                market_value = midfield_player(player_name)
            elif position == "Defender":
                market_value = defend_player(player_name)
            elif position == "Goalkeeper":
                market_value = goalkeep_player(player_name)
            #score = model_score()
            #score = int(score * 100)
            marketvalue = int(market_value)
            result = f"Market value of {player_name} is {marketvalue} million euros."    
        except Exception as e:
            result = f"{player_name} is not in the current Test DataSet"
            flash(result)
            
        return render_template('index.html', result=result)
    

if __name__ == '__main__':
    app.run(debug=True)