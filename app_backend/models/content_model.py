class ComplaintModel(object):
    def __init__(self, id, senderId,lang,complaintText,audioURL,timestamp,output,ots):
        self.id = id
        self.senderId = senderId
        self.lang = lang
        self.complaintText = complaintText
        self.audioURL = audioURL
        self.timestamp = timestamp
        self.output=output
        self.ots=ots
    
    def from_dict(data):
        return ComplaintModel(
            id=data.get('id'),
            senderId=data.get('senderId'),
            lang=data.get('lang').lower(),
            complaintText=data.get('complaintText'),
            audioURL=data.get('audioURL'),
            timestamp=data.get('timestamp'),
            output=data.get('output'),
            ots=data.get('ots'),
            )
    
