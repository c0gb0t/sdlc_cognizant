from cms_backend.models.complaint_model import ComplaintModel
from cms_backend.utils.ft5 import categorize
from cms_backend.utils.indictrans2 import translate
from cms_backend.utils.indicwav2vec import convert_stt
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime
import json
import threading
import time

from pandas import Timestamp



def listen_msgs():
    coll_name='mh_bhasha3'
    user_uid='mh_bhasa3_user'
        


    if not firebase_admin._apps:
        # Use a service account.
        cred = credentials.Certificate(f'../keys/sa.json')
        app = firebase_admin.initialize_app(cred)

    db = firestore.client()
    
    # Create an Event for notifying main thread.
    callback_done = threading.Event()

    # Create a callback on_snapshot function to capture changes
    def on_snapshot(doc_snapshot, changes, read_time):
        for doc in doc_snapshot:
            print(f"Received document snapshot: {doc.id}")
            complaint=ComplaintModel.from_dict(doc.to_dict())
            print(doc.to_dict())
            # data=doc.to_dict()
            if complaint.audioURL!='':
                complaint.complaintText=convert_stt(complaint=complaint)
            if complaint.lang!='English':
                complaint.complaintText=translate(complaint=complaint)

            pred_res=categorize(complaint.complaintText)
            # pred_res={'output':"model response"}

            complaint.senderId='backend@red'
            complaint.output=pred_res['output']
            # data['priority']=pred_res['output'].split(':')[-1]
            complaint.ots=datetime.datetime.utcnow()
            print(f'sending response: '+complaint.output)
            doc_id=str(round(time.time() * 1000))
            db.collection(coll_name).document(user_uid).collection('pComplaints').document(doc_id).set(complaint.__dict__)
            print(f"----------sent----------------with id: {doc_id} ")

        callback_done.set()

    doc_ref = db.collection(coll_name).document(user_uid).collection('rComplaints').document("complaint")

    # Watch the document
    doc_watch = doc_ref.on_snapshot(on_snapshot)
    

    while True:
        print('', end='', flush=True)
        time.sleep(1)

