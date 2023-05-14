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

def readall_data():
    data = pd.read_csv("upd_pldata.csv")
    data = data.dropna()
    return data

def market_value(x):
    mf_data = readall_data()
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

    regr = RandomForestRegressor(max_depth=5, random_state=0)
    regr.fit(X_train_mf, y_train_mf)
    regr.score(X_test_mf,y_test_mf)
    predictions = regr.predict(X_test_mf)
    final_mf["predictions"] = predictions
    pd.options.display.float_format = '{:.0f}'.format
    marketvalue = final_mf.query("`Name` == '" + x + "'")["predictions"].values[0]
    return marketvalue

def model_score():
    mf_data = readall_data()
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

    regr = RandomForestRegressor(max_depth=5, random_state=0)
    regr.fit(X_train_mf, y_train_mf)
    return regr.score(X_test_mf,y_test_mf)

