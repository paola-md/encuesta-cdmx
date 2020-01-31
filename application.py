# -*- coding: utf-8 -*-
#import cs50
import csv
import os
import datetime
import sqlite3
import psycopg2

#DATABASE_URL = os.environ['postgres://alvtpzycglidaz:c141b7b9607ef4fe357461796c5252e6b505ad9407fb1c2cfa0cd094b3a05e30@ec2-107-22-222-161.compute-1.amazonaws.com:5432/dco646ec5hp31h']

DATABASE_URL = os.environ['DATABASE_URL']
conn = psycopg2.connect(DATABASE_URL, sslmode='require')
conn.autocommit = True
cursor = conn.cursor()
print("Opened database successfully")

from flask import Flask, jsonify, redirect, render_template, request

# Configure application
app = Flask(__name__)

# Reload templates when they are changed
app.config["TEMPLATES_AUTO_RELOAD"] = True

@app.after_request
def after_request(response):
    """Disable caching"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET"])
def get_index():
    return redirect("/form")


@app.route("/form", methods=["GET"])
def get_form():
    return render_template("form.html")

    #f = open("survey.csv","w+")


@app.route("/form", methods=["POST"])
def post_form():
    comida = request.form.get("comida")
    pais = request.form.get("pais")
    color = request.form.get("color")

    #date = str(datetime.date.today())
    if not comida or not pais or not color:
        return render_template("error.html", message="Please fill in all values!")

    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    with conn.cursor() as cursor:
        sql_instr = "insert into preferences(nourriture,pays, couleur) VALUES(" + "'{}'".format(str(comida)) + " , " + "'{}'".format(str(pais))  +" , " + "'{}'".format(str(color)) +")"
        cursor.execute(sql_instr)
        conn.commit()
        conn.close()

    return redirect("/sheet")

@app.route("/sheet", methods=["GET"])
def get_sheet():

    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM preferences");
        #conn.commit()
        students = cursor.fetchall()
        return render_template("survey.html", students=students)
        conn.close()


if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)