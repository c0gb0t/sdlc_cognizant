from cms_backend.models.complaint_model import ComplaintModel
import torch
from transformers import AutoModelForCTC, AutoProcessor
import torchaudio.functional as F
import pyctcdecode
from transformers import AutoModelForCTC, Wav2Vec2Processor, Wav2Vec2ProcessorWithLM, pipeline
import torchaudio
import requests

DEVICE_ID = "cuda" if torch.cuda.is_available() else "cpu"
asr_langs={'bengali':'bn','gujarati':'gu','hindi':'hi','marathi':'mr','nepali':'ne','odia':'or','tamil':'ta','telugu':'te','sinhala':'se'}
# asr_model_ids={'hindi':"ai4bharat/indicwav2vec-hindi"}
asr_model_ids=dict([(x,f'ai4bharat/indicwav2vec_v1_{x}') for x in asr_langs.keys()])
asr_models={}
asr_processors = {}

def load_asr_models():
    for lang in asr_langs:
        asr_models[lang]=AutoModelForCTC.from_pretrained(asr_model_ids[lang]).to(DEVICE_ID)
        asr_processors[lang]=Wav2Vec2Processor.from_pretrained(asr_model_ids[lang])


    return


def load_audio_from_url(url):
    local_filename = url.split('/')[-1]
    # NOTE the stream=True parameter below
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    file_path=local_filename
    waveform, sample_rate = torchaudio.load(file_path)
    num_channels, _ = waveform.shape
    if num_channels == 1:
        return waveform[0], sample_rate
    else:
        raise ValueError("Waveform with more than 1 channels are not supported.")    

def convert_stt(complaint:ComplaintModel):
    if complaint.lang not in asr_models:
        asr_models[complaint.lang]=AutoModelForCTC.from_pretrained(asr_model_ids[complaint.lang]).to(DEVICE_ID)
        asr_processors[complaint.lang]=Wav2Vec2Processor.from_pretrained(asr_model_ids[complaint.lang])
    #Load from url
    waveform, sample_rate = load_audio_from_url(complaint.audioURL)
    resampled_audio = torchaudio.functional.resample(waveform, sample_rate, 16000)
    input_values = asr_processors[complaint.lang](resampled_audio, return_tensors="pt").input_values

    with torch.no_grad():
        logits = asr_models[complaint.lang](input_values.to(DEVICE_ID)).logits.cpu()
    
    prediction_ids = torch.argmax(logits, dim=-1)
    output_str = asr_processors[complaint.lang].batch_decode(prediction_ids)[0]
    print(f"Greedy Decoding: {output_str}")
    return output_str

