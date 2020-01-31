# -*- coding: utf-8 -*-
import cs50
import csv
import os
import datetime
import sqlite3

conn = sqlite3.connect("survey.db")
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
    name = request.form.get("name")
    nick = request.form.get("nick")
    hobby = request.form.get("hobby")
    quote = request.form.get("quote")
    size = request.form.get("size")
    gender = request.form.get("gender")
    role = request.form.get("role")
    date = str(datetime.date.today())
    if not name or not size or not gender or not role:
        return render_template("error.html", message="Please fill in all values!")
    # file = open("survey.csv","a")
    # writer = csv.writer(file)
    # writer.writerow((name, nick, gender, hobby, quote, role, date))
    # file.close()
    with sqlite3.connect("survey.db") as con:
        cur = con.cursor();
        cur.execute("INSERT INTO players(name, nick, hobby, quote, gender, size, role, date) VALUES(?,?,?,?,?,?,?,?)",(name, nick, hobby, quote, gender, size, role, date));
        con.commit();
    return redirect("/sheet")

@app.route("/sheet", methods=["GET"])
def get_sheet():
    # file = open("survey.csv", "r")
    # reader = csv.reader(file)
    #students = list(reader)
    with sqlite3.connect("survey.db") as con:
        cur = con.cursor();
        students = cur.execute("SELECT * FROM players");
        con.commit();
        return render_template("survey.html", students=students)
        con.close();

if __name__ == '__main__':
    # Bind to PORT if defined, otherwise default to 5000.
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)