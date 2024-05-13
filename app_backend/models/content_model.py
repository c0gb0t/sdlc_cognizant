class ContentModel():
    def __init__(self, id, senderId,fileUrls,timestamp,output,ots):
        self.id = id
        self.senderId = senderId
        self.fileUrls = fileUrls
        self.timestamp = timestamp
        self.output=output
        self.ots=ots
    
    def from_dict(self,data):
        return ContentModel(
            id=data.get('id'),
            senderId=data.get('senderId'),
            fileUrls=data.get('fileUrls'),
            timestamp=data.get('timestamp'),
            output=data.get('output'),
            ots=data.get('ots'),
            )
    
