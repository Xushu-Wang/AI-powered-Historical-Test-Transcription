# Constants
FONT_NAME="Parisienne-Regular"
MAX_PAGES=10
NUM_ITERATIONS=400

# Remove the previosly generated training data
rm -rf train/*

# Generate training data
tesstrain.sh--fonts_dir fonts 
			--fontlist "Parisienne-Regular" 
			--lang eng 
			--linedata_only 
			--langdata_dir ./tesseract/langdata_lstm --tessdata_dir ./tesseract/tessdata \
 			--maxpages 10 --output_dir train

# Extract the best trainned model
combine_tessdata -e ./tesseract/tessdata/eng.traineddata eng.lstm

# Fine tune the model
rm -rf output/*
OMP_THREAD_LIMIT=8 lstmtraining 
	--continue_from eng.lstm 
	--model_output output/jokerman 
	--traineddata tesseract/tessdata/eng.traineddata \
	--train_listfile ./train/eng.training_files.txt --max_iterations $NUM_ITERATIONS

# Combine the checkpoints and create the final model
lstmtraining--stop_training 
			--continue_from output/jokerman_checkpoint 
			--traineddata ./tesseract/tessdata/eng.traineddata \
			--model_output output/jokerman.traineddata