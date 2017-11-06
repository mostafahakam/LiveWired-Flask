from peewee import *
from playhouse.sqlite_ext import SqliteExtDatabase
import datetime

db = SqliteExtDatabase('database.db')


class BaseModel(Model):
    class Meta:
        database = db


class Transcript(BaseModel):
    user_id = TextField()
    script = TextField()
    created_date = DateTimeField(default=datetime.datetime.now)


def addTranscript(user_id, transcript):
    t = Transcript.create(user_id=user_id, script=transcript)
    t.save()


def getTranscript(user_id):
    return Transcript.select().where(Transcript.user_id == user_id).get()
