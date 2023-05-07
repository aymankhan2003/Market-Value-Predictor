import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import Lasso
from sklearn.linear_model import LinearRegression
import os

path = os.getcwd()

os.chdir("/Users/ayman/OneDrive/Documents/GitHub/Market-Value-Predictor")

def readall_data():
    data = pd.read_csv("upd_pldata.csv")
    data = data.dropna()
    return data

def readmf_data():
    data = pd.read_csv("midfielder_data.csv")
    data = data.dropna()
    return data

def readgk_data():  
    data = pd.read_csv("goalkeeper_data.csv")
    data = data.dropna()
    return data
    
def readdf_data(): 
    data = pd.read_csv("defender_data.csv")
    data = data.dropna()
    return data
    
def readat_data():
    data = pd.read_csv("attacker_data.csv")
    data = data.dropna()
    return data

def midfield_player(x):
    mf_data = readmf_data()
    mf_train, mf_test = train_test_split(mf_data, test_size = 0.5, shuffle = True)

    final_mf = pd.DataFrame(mf_test, columns = ["Name"])
    final_mf["actual"] = mf_test['Value'].copy()
    

    #getting the target vector
    X_train_mf = mf_train.drop(["Value"], axis = 1)
    y_train_mf = mf_train["Value"]

    X_test_mf = mf_test.drop(["Value"], axis = 1)
    y_test_mf = mf_test["Value"]

    X_train_mf = X_train_mf.drop(["field_position"], axis = 1)
    X_train_mf = X_train_mf.drop(["Name"], axis = 1)



    X_test_mf = X_test_mf.drop(["field_position"], axis = 1)
    X_test_mf = X_test_mf.drop(["Name"], axis = 1)

    reg4 = LinearRegression().fit(X_train_mf, y_train_mf)
    reg4.score(X_test_mf,y_test_mf)
    predictions = reg4.predict(X_test_mf)
    final_mf["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    marketvalue = final_mf.query("`Name` == '" + x + "'")["predictions"].values[0]
    return marketvalue
    

def goalkeep_player(x):
    gk_data = readgk_data()
    gk_train, gk_test = train_test_split(gk_data, test_size = 0.5, shuffle = True)

    final_gk = pd.DataFrame(gk_test, columns = ["Name"])
    final_gk["actual"] = gk_test['Value'].copy()
    

    #getting the target vector
    X_train_gk = gk_train.drop(["Value"], axis = 1)
    y_train_gk = gk_train["Value"]

    X_test_gk = gk_test.drop(["Value"], axis = 1)
    y_test_gk = gk_test["Value"]

    X_train_gk = X_train_gk.drop(["field_position"], axis = 1)
    X_train_gk = X_train_gk.drop(["Name"], axis = 1)



    X_test_gk = X_test_gk.drop(["field_position"], axis = 1)
    X_test_gk = X_test_gk.drop(["Name"], axis = 1)

    reg4 = LinearRegression().fit(X_train_gk, y_train_gk)
    reg4.score(X_test_gk,y_test_gk)
    predictions = reg4.predict(X_test_gk)
    final_gk["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    marketvalue = final_gk.query("`Name` == '" + x + "'")["predictions"].values[0]
    return marketvalue
    

def defend_player(x):
    df_data = readdf_data()
    df_train, df_test = train_test_split(df_data, test_size = 0.5, shuffle = True)

    final_df = pd.DataFrame(df_test, columns = ["Name"])
    final_df["actual"] = df_test['Value'].copy()
    

    #getting the target vector
    X_train_df = df_train.drop(["Value"], axis = 1)
    y_train_df = df_train["Value"]

    X_test_df = df_test.drop(["Value"], axis = 1)
    y_test_df = df_test["Value"]

    X_train_df = X_train_df.drop(["field_position"], axis = 1)
    X_train_df = X_train_df.drop(["Name"], axis = 1)



    X_test_df = X_test_df.drop(["field_position"], axis = 1)
    X_test_df = X_test_df.drop(["Name"], axis = 1)

    reg4 = LinearRegression().fit(X_train_df, y_train_df)
    reg4.score(X_test_df,y_test_df)
    predictions = reg4.predict(X_test_df)
    final_df["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    marketvalue = final_df.query("`Name` == '" + x + "'")["predictions"].values[0]
    return marketvalue
    

def attacking_player(x):
    at_data = readat_data()
    at_train, at_test = train_test_split(at_data, test_size = 0.5, shuffle = True)

    final_at = pd.DataFrame(at_test, columns = ["Name"])
    final_at["actual"] = at_test['Value'].copy()
    

    #getting the target vector
    X_train_at = at_train.drop(["Value"], axis = 1)
    y_train_at = at_train["Value"]

    X_test_at = at_test.drop(["Value"], axis = 1)
    y_test_at = at_test["Value"]

    X_train_at = X_train_at.drop(["field_position"], axis = 1)
    X_train_at = X_train_at.drop(["Name"], axis = 1)



    X_test_at = X_test_at.drop(["field_position"], axis = 1)
    X_test_at = X_test_at.drop(["Name"], axis = 1)

    reg4 = LinearRegression().fit(X_train_at, y_train_at)
    reg4.score(X_test_at,y_test_at)
    predictions = reg4.predict(X_test_at)
    final_at["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    marketvalue = final_at.query("`Name` == '" + x + "'")["predictions"].values[0]
    return marketvalue

def model_score():
    all_players = readall_data()
    final_all_players = pd.DataFrame(all_players, columns = ["Name"])
    final_all_players["actual"] = all_players['Value'].copy()
    all_train, all_test = train_test_split(all_players, test_size = .2, shuffle = True)


    X_train_all = all_train.dropna(how='any', inplace=True)
    X_train_all = all_train.drop(["Value"], axis = 1)
    y_train_all = all_train["Value"]



    X_test_all = all_test.dropna(how='any', inplace=True)
    X_test_all = all_test.drop(["Value"], axis = 1)
    y_test_all = all_test["Value"]

    X_train_all = X_train_all.drop(["field_position"], axis = 1)
    X_train_all = X_train_all.drop(["Name"], axis = 1)


    X_test_all = X_test_all.drop(["field_position"], axis = 1)
    X_test_all = X_test_all.drop(["Name"], axis = 1)
    
    Lol = Lasso(alpha = 0.0001)
    Lol.fit(X_train_all, y_train_all)
    return Lol.score(X_test_all, y_test_all)