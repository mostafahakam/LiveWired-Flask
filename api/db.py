from peewee import *
from playhouse.sqlite_ext import SqliteExtDatabase
import datetime

db = SqliteExtDatabase('database.db')


class BaseModel(Model):
    class Meta:
        database = db


class Transcript(BaseModel):
    username = TextField()
    script = TextField()
    created_date = DateTimeField(default=datetime.datetime.now)


def addTranscript(username, transcript):
    t = Transcript.create(username=username, script=transcript)
    t.save()


def getTranscript(username):
    user = Transcript.get(Transcript.username == username)
