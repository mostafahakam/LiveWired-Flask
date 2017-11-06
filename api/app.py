#!flask/bin/python
import json
from flask import Flask, jsonify, make_response, abort, request
from db import *
from playhouse.shortcuts import model_to_dict, dict_to_model


app = Flask(__name__)

tasks = [
    {
        'id': 1,
        'title': u'Buy groceries',
        'description': u'Milk, Cheese, Pizza, Fruit, Tylenol',
        'done': False
    },
    {
        'id': 2,
        'title': u'Learn Python',
        'description': u'Need to find a good Python tutorial on the web',
        'done': False
    }
]


@app.before_request
def before_request():
    db.connect()


@app.after_request
def after_request(response):
    db.close()
    return response


@app.route('/api/v1/db/clear', methods=['POST'])
def clear_transcripts():
    Transcript.delete().execute()
    return make_response(jsonify({'Success': 'Database cleared'}), 201)


@app.route('/api/v1/transcript/<string:user_id>', methods=['PUT'])
def add_transcript(user_id):
    request_json = request.get_json()
    addTranscript(user_id, request_json['script'])
    return make_response(jsonify({'Success': 'Script added'}), 201)


@app.route('/api/v1/transcript/<string:user_id>', methods=['GET'])
def get_transcript(user_id):
    scripts = getTranscript(user_id)
    scripts_json = []

    for script in scripts:
        scripts_json.append(model_to_dict(script))

    return make_response(jsonify(json.dumps(scripts_json)), 201)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)



if __name__ == '__main__':
    app.run(host='0.0.0.0')
