# # To use ccl as the distributed backend in distributed training on CPU requires to install below requirement.
# python -m pip install oneccl_bind_pt -f https://developer.intel.com/ipex-whl-stable-cpu

# cd "/home/u131168/mh_shell/ft_model_pp/itp"
# # pip install intel-extension-for-transformers
# # pip install fschat==0.1.2


echo "starting fine tuning model"
# cd "/home/u131168/mh_shell/ft_model_pp/itp"
pip3 install -r "./itp/reqs.txt"
# pip3 install git+https://github.com/huggingface/transformers
# pip3 install tokenizers



# sbatch -x idc-beta-batch-pvc-node-[03,20,21] --job-name fts1 --priority=0 ft_mod1.sh
# sbatch -w idc-beta-batch-pvc-node-[05] --job-name fts1 --priority=0 ft_mod1.sh

# export wd_path="E:\ETC\Progress\Projects\web_app\mh_bhasha3\cms_backend\finetune"
# export wd_path="~/mh_bhasha3/cms_backend/finetune"

export train_file="./f_data.csv"

export model_path="google/flan-t5-xl"
# export model_path="/home/u131168/mh_shell/ft_models/flan-t5-xl_mt5_v1"

# export checkpoint_path="/home/u131168/mh_shell/ft_models/flan-t5-xl_peft_finetuned_model/checkpoint-36000"
export checkpoint_dir="./ft_models/flan-t5-xl-mt5-v1/"
export checkpoint_name=$(ls $checkpoint_dir | grep checkpoint | tail -2 | head -n 1)
# export checkpoint_name=$(ls $checkpoint_dir | grep checkpoint | tail -2 | sort -r | head -n 1)

export checkpoint_path="$checkpoint_dir$checkpoint_name"
echo $checkpoint_path

export output_dir="$checkpoint_dir"




python "./itp/finetune_seq2seq.py" \
        --model_name_or_path $model_path \
        --resume_from_checkpoint $checkpoint_path \
        --bf16 True \
        --train_file $train_file \
        --per_device_train_batch_size 2 \
        --per_device_eval_batch_size 2 \
        --gradient_accumulation_steps 1 \
        --do_train \
        --learning_rate 1.0e-6 \
        --warmup_ratio 0.03 \
        --weight_decay 0.0 \
        --num_train_epochs 1 \
        --logging_steps 10 \
        --save_steps 100 \
        --save_total_limit 2 \
        --overwrite_output_dir \
        --output_dir $output_dir \
        --peft lora

echo "finished fine tuning model"