from flask import Flask, render_template, request, flash, redirect, url_for
from marketvaluemodule import market_value, model_score
from transferfeemodule import transferfee, model_score2, transferfeetable, transferfeetablefd
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
    accuracy_result = f"Accuracy of our model is {accuracy}%"
    return render_template('index.html', result=accuracy_result)

@app.route('/accuracy2')
def accuracy2():
    accuracy2 = model_score2()
    accuracy2 = int(accuracy2 * 100)
    accuracy_result = f"Accuracy of our model is {accuracy2}%"
    return render_template('index.html', result2=accuracy_result)


@app.route('/', methods=['POST'])
def get_value():
    if request.form.get('reset') == 'Reset':
        return render_template('index.html')
    elif request.form.get('accuracy') == 'Accuracy for Market Model':
        return redirect(url_for('accuracy'))
    else:
        player_name = request.form['player_name']
        try:
            marketvalue = int(market_value(player_name))
            result = f"Market value of {player_name} is {marketvalue} euros."
        except Exception as e:
            result = f"{player_name} is not in the current Test DataSet"
            flash(result)
            
        return render_template('index.html', result=result)

@app.route('/transfer', methods=['POST'])
def get_value2():
    if request.form.get('reset') == 'Reset':
        return render_template('index.html')
    elif request.form.get('accuracy2') == 'Accuracy for Transfer Model':
        return redirect(url_for('accuracy2'))
    else:
        transfer_table = transferfeetable()
        transfer_player = request.form['transfer_player']
        team_name = request.form['team_name']
        try:
            table = transfer_table
            transfer_fee = int(transferfee(transfer_player))
            result2 = f"If {team_name} were to buy {transfer_player}, they would have to pay {transfer_fee} euros."
        except Exception as e:
            table = transfer_table
            result2 = f"{transfer_player} is not in the current Test DataSet"
            flash(result2)
            
        return render_template('index.html', result2=result2, table=table)
    
if __name__ == '__main__':
    app.run(debug=True)