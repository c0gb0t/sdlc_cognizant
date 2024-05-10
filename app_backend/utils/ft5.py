from peft import AutoPeftModelForSeq2SeqLM
from transformers import AutoTokenizer
import torch
import numpy as np
import pandas as pd
import torch
import subprocess
import time
from ..finetune import instruction


wd_path='E:\ETC\Progress\Projects\web_app\mh_bhasha3\cms_backend'

lcp_path=f'{wd_path}/fintune/ft_model/ft5cp1.cp'
model_path=lcp_path
# model_path='google/flant5-xl'

ft5_model = AutoPeftModelForSeq2SeqLM.from_pretrained(model_path, )
ft5_tokenizer = AutoTokenizer.from_pretrained(model_path)


def categorize(complaint):
    print("-------------generating response-----------------")
    context=complaint.complaintText
    context=context.replace('\n',' \\n ')
    context=context.replace('\t',' \\t ')

    input=f'complaint: {context}'
    prompts=[[instruction,input]]
    res=[]
    input_ids = ft5_tokenizer(prompts, return_tensors="pt" ,padding=True,truncation=True, max_length=512).input_ids
    start_time = time.time()
    outputs = ft5_model.generate(input_ids=input_ids, do_sample=True, max_length=150)
    pt=time.time() - start_time
    print(f"--------------time taken by normal model={pt} seconds")

    res+=ft5_tokenizer.batch_decode(outputs, skip_special_tokens=True)

    return  { 'output': f'{res[0]}' }
