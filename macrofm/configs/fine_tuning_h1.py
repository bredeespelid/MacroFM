from configs.fine_tuning import *  # arver baseline fra vendor/timesfm_fin/configs

# Kvartalsvis h=1 – lett røyktest
optimizer = 'sgd'
warmup_epochs = 5
num_epochs = 30
lr_peak = 1e-4
momentum = 0.9
grad_clip = 1.0

batch_size = 64
min_context_len = 16
max_context_len = 64
input_len = 32
output_len = 1
