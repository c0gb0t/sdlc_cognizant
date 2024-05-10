# code for translation

import torch
from transformers import AutoModelForSeq2SeqLM
from IndicTransTokenizer import IndicProcessor, IndicTransTokenizer

trans_langs={"hindi":'hin_Deva'}
trans_tokenizer = IndicTransTokenizer(direction="indic-en")
trans_ip = IndicProcessor(inference=True)
trans_model = AutoModelForSeq2SeqLM.from_pretrained("ai4bharat/indictrans2-indic-en-dist-200M", trust_remote_code=True)

def translate(complaint):
    input=[complaint.complainText]
        
    batch = trans_ip.preprocess_batch(input, src_lang=trans_langs[complaint.lang], tgt_lang="eng_Latn")
    batch = trans_tokenizer(batch, src=True, return_tensors="pt")

    with torch.inference_mode():
        outputs = trans_model.generate(**batch, num_beams=5, num_return_sequences=1, max_length=256)

    outputs = trans_tokenizer.batch_decode(outputs, src=False)
    outputs = trans_ip.postprocess_batch(outputs, lang=trans_langs[complaint.lang])
    print(outputs)
    return outputs[0]

