# -*- coding: utf-8 -*-
#import cs50
import csv
import os
import datetime
import sqlite3
import psycopg2
import random

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
    idsha = str(request.args.get('idsha'))
    return render_template("form.html", value = idsha)


@app.route("/form", methods=["POST"])
def post_form():
    rand = random.randint(0,9)
    if rand < 5:
        new_dir = "https://www.plataformadetransparencia.org.mx/web/guest/inicio"
        return redirect(new_dir)
    else:
        return render_template("gracias.html")

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