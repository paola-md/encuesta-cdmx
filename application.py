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


@app.route("/form", methods=["GET","POST"])
def post_form():
    comida = request.form.get("comida")
    pais = request.form.get("pais")
    color = str(request.args.get('key'))
    if len(color) == 0:
        color = "vacio"

    #date = str(datetime.date.today())
    if not comida or not pais or not color:
        return render_template("error.html", message="Please fill in all values!")

    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    with conn.cursor() as cursor:
        sql_instr = "insert into preferences(nourriture,pays, couleur) VALUES(" + "'{}'".format(str(comida)) + " , " + "'{}'".format(str(pais))  +" , " + "'{}'".format(str(color)) +")"
        cursor.execute(sql_instr)
        conn.commit()
        conn.close()
        new_dir = "/after_survey?food=" + str(comida)
    return redirect(new_dir)

@app.route("/after_survey", methods=["GET"])
def get_food():
    nourriture = str(request.args.get('food'))
    if nourriture == "tacos":
        nueva_pag = "https://local.mx/restaurantes/comida-callejera/el-autentico-pato-manila-un-localito-de-puro-pato-en-la-condesa/"
    else:
        nueva_pag = "https://www.google.com/search?q=comida+" + nourriture
    return redirect(nueva_pag, code=302 )  


if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)