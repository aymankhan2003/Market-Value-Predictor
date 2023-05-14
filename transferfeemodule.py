import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import Lasso
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
import os

path = os.getcwd()

os.chdir("/Users/ayman/OneDrive/Documents/GitHub/Market-Value-Predictor")

def readdata():
    tf2_data = pd.read_csv("transfer fee_final.csv")
    tf2_data.columns = tf2_data.columns.str.replace('.', '_')
    tf2_data.columns = tf2_data.columns.str.replace('___', '_')
    tf2_data.columns = tf2_data.columns.str.replace(' ', '_')
    tf2_data = tf2_data.dropna()
    return tf2_data
    


def transferfeetablefd():
    tf2_data = readdata()
    tf2_data["fee_cleaned"] = tf2_data["fee_cleaned"]*1000000
    

    tf2_data_field_index = tf2_data["position_x"] != "Goalkeeper"
    tf2_data_field = tf2_data[tf2_data_field_index]

    tf2_data_field_index_2 = tf2_data_field["fee_cleaned"] > 0
    tf2_data_field = tf2_data_field[tf2_data_field_index_2]

    buyer_avg_tf = tf2_data_field.groupby("team")["fee_cleaned"].mean()
    seller_avg_tf = tf2_data_field.groupby("club_involved_name")["fee_cleaned"].mean()
    
    tf2_data_field = pd.merge(tf2_data_field, buyer_avg_tf, on='team', how='left', suffixes=('', '_buyer_avg'))
    tf2_data_field = pd.merge(tf2_data_field, seller_avg_tf, on='club_involved_name', how='left', suffixes=('', '_seller_avg'))
    field_tf_upd_train, field_tf_upd_test = train_test_split(tf2_data_field, test_size = .2, shuffle = True)

    final_tf_upd = pd.DataFrame(field_tf_upd_test, columns = ["player_name"])
    final_tf_upd["actual"] = field_tf_upd_test['fee_cleaned'].copy()
    
    #re-clean; non-numerical stuff
    field_tf_upd_train = field_tf_upd_train.drop(["team"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["player_name"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["nationality_name"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["position_x"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["league_name_x_y"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["club_involved_name"], axis = 1)

    #re-clean; non-numerical stuff
    field_tf_upd_test = field_tf_upd_test.drop(["team"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["player_name"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["nationality_name"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["position_x"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["league_name_x_y"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["club_involved_name"], axis = 1)
    
    X_train_fee = field_tf_upd_train.drop(["fee_cleaned"], axis = 1)
    y_train_fee = field_tf_upd_train["fee_cleaned"]

    X_test_fee = field_tf_upd_test.drop(["fee_cleaned"], axis = 1)
    y_test_fee = field_tf_upd_test["fee_cleaned"]
    
    X_train_fee = X_train_fee[['value_eur', 'overall', 'potential', 'attacking_short_passing',
       'power_shot_power', 'mentality_vision', 'goalkeeping_kicking', 'wins',
       'missed', 'pts', 'xG', 'xGA', 'npxGA', 'npxGD', 'oppda_coef', 'deep',
       'xpts', 'xpts_diff', 'SPI', 'tranfer_activity', 'fee_cleaned_buyer_avg',
       'fee_cleaned_seller_avg']]

    X_test_fee = X_test_fee[['value_eur', 'overall', 'potential', 'attacking_short_passing',
       'power_shot_power', 'mentality_vision', 'goalkeeping_kicking', 'wins',
       'missed', 'pts', 'xG', 'xGA', 'npxGA', 'npxGD', 'oppda_coef', 'deep',
       'xpts', 'xpts_diff', 'SPI', 'tranfer_activity', 'fee_cleaned_buyer_avg',
       'fee_cleaned_seller_avg']]
    
    regr = RandomForestRegressor(max_depth = 15, random_state=0)
    regr.fit(X_train_fee, y_train_fee)
    regr.score(X_test_fee, y_test_fee)
    
    predictions = regr.predict(X_test_fee)
    final_tf_upd["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    
    return final_tf_upd

def transferfeetable():
    table = transferfeetablefd()
    return table['player_name']

def transferfee(x):
    table = transferfeetablefd()
    transferfee = table.query("`player_name` == '" + x + "'")["predictions"].values[0]
    return transferfee

def model_score2():
    tf2_data = readdata()
    tf2_data["fee_cleaned"] = tf2_data["fee_cleaned"]*1000000
    

    tf2_data_field_index = tf2_data["position_x"] != "Goalkeeper"
    tf2_data_field = tf2_data[tf2_data_field_index]

    tf2_data_field_index_2 = tf2_data_field["fee_cleaned"] > 0
    tf2_data_field = tf2_data_field[tf2_data_field_index_2]

    buyer_avg_tf = tf2_data_field.groupby("team")["fee_cleaned"].mean()
    seller_avg_tf = tf2_data_field.groupby("club_involved_name")["fee_cleaned"].mean()
    
    tf2_data_field = pd.merge(tf2_data_field, buyer_avg_tf, on='team', how='left', suffixes=('', '_buyer_avg'))
    tf2_data_field = pd.merge(tf2_data_field, seller_avg_tf, on='club_involved_name', how='left', suffixes=('', '_seller_avg'))
    field_tf_upd_train, field_tf_upd_test = train_test_split(tf2_data_field, test_size = .2, shuffle = True)

    final_tf_upd = pd.DataFrame(field_tf_upd_test, columns = ["player_name"])
    final_tf_upd["actual"] = field_tf_upd_test['fee_cleaned'].copy()
    
    #re-clean; non-numerical stuff
    field_tf_upd_train = field_tf_upd_train.drop(["team"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["player_name"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["nationality_name"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["position_x"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["league_name_x_y"], axis = 1)
    field_tf_upd_train = field_tf_upd_train.drop(["club_involved_name"], axis = 1)

    #re-clean; non-numerical stuff
    field_tf_upd_test = field_tf_upd_test.drop(["team"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["player_name"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["nationality_name"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["position_x"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["league_name_x_y"], axis = 1)
    field_tf_upd_test = field_tf_upd_test.drop(["club_involved_name"], axis = 1)
    
    X_train_fee = field_tf_upd_train.drop(["fee_cleaned"], axis = 1)
    y_train_fee = field_tf_upd_train["fee_cleaned"]

    X_test_fee = field_tf_upd_test.drop(["fee_cleaned"], axis = 1)
    y_test_fee = field_tf_upd_test["fee_cleaned"]
    
    X_train_fee = X_train_fee[['value_eur', 'overall', 'potential', 'attacking_short_passing',
       'power_shot_power', 'mentality_vision', 'goalkeeping_kicking', 'wins',
       'missed', 'pts', 'xG', 'xGA', 'npxGA', 'npxGD', 'oppda_coef', 'deep',
       'xpts', 'xpts_diff', 'SPI', 'tranfer_activity', 'fee_cleaned_buyer_avg',
       'fee_cleaned_seller_avg']]

    X_test_fee = X_test_fee[['value_eur', 'overall', 'potential', 'attacking_short_passing',
       'power_shot_power', 'mentality_vision', 'goalkeeping_kicking', 'wins',
       'missed', 'pts', 'xG', 'xGA', 'npxGA', 'npxGD', 'oppda_coef', 'deep',
       'xpts', 'xpts_diff', 'SPI', 'tranfer_activity', 'fee_cleaned_buyer_avg',
       'fee_cleaned_seller_avg']]
    
    regr = RandomForestRegressor(max_depth = 15, random_state=0)
    regr.fit(X_train_fee, y_train_fee)
    return regr.score(X_test_fee, y_test_fee)
