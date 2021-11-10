#Step1: download relevant codes
	wget "https://www.dropbox.com/s/q3xlngls3ysl3ad/Prep_Mapper.py"
	wget "https://www.dropbox.com/s/1cksusjtq9qx8jx/Prep_Reducer.py"
	wget "https://www.dropbox.com/s/8fcnyutsbd1h6np/mapper.py"
	wget "https://www.dropbox.com/s/u19tud5jpetyzkn/reducer.py"
	wget "https://www.dropbox.com/s/egogsrgt44tjkmz/Iterative_Dijikstra_Hadoop.sh"
	
#Step 2: provide relevant access permission 
	chmod +x *.py
	chmod +x *.sh
#Step 3: Create the relevant directory structure 
	hdfs dfs -mkdir Working_Dir
	hdfs dfs -mkdir /user/hadoop/Working_Dir/RawData_Input_Dir

#Step 4: Download Raw data form ( NodeID, NeighborID, Weight) from SNAP. 
	#Dataset 1: email-Eu-core temporal network (Nodes	986 , Temporal Edges 332,334)
	wget "https://snap.stanford.edu/data/email-Eu-core-temporal.txt.gz"
	gunzip email-Eu-core-temporal.txt.gz
	hdfs dfs -put  email-Eu-core-temporal.txt /user/hadoop/Working_Dir/RawData_Input_Dir
	#Dataset 2: wiki-talk temporal network (Nodes	1,140,149, Temporal Edges 7,833,140)
	wget "https://snap.stanford.edu/data/wiki-talk-temporal.txt.gz"
	gunzip wiki-talk-temporal.txt.gz
	hdfs dfs -put  wiki-talk-temporal.txt /user/hadoop/Working_Dir/RawData_Input_Dir
	#Dataset 3: Stack Overflow temporal network (Nodes 2,601,977, Temporal Edges 63,497,050)
	wget "https://snap.stanford.edu/data/sx-stackoverflow.txt.gz"
	gunzip sx-stackoverflow.txt.gz
	hdfs dfs -put  sx-stackoverflow.txt /user/hadoop/Working_Dir/RawData_Input_Dir

#Note that for each data you will need to delete the Working_Dir then follow step 3 throughout 7
	hdfs dfs -rm -r -f  /user/hadoop/Working_Dir
	
	
#Step 5: Run the data cleaning and reformating job: Note this will create the input directory for the next Dijikstra stream job 
	time hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
	-input /user/hadoop/Working_Dir/RawData_Input_Dir \
	-output /user/hadoop/Working_Dir/Input_Dir \
	-file /home/hadoop/Prep_Mapper.py \
	-mapper /home/hadoop/Prep_Mapper.py \
	-file /home/hadoop/Prep_Reducer.py \
	-reducer /home/hadoop/Prep_Reducer.py 

#Step 7: Run the iterative dijikstra
	Input_Dir=/user/hadoop/Working_Dir/Input_Dir
	Output_Dir=/user/hadoop/Working_Dir/Output_Dir
	Mapper=/home/hadoop/mapper.py
	Reducer=/home/hadoop/reducer.py
	time ./Iterative_Dijikstra_Hadoop.sh $Input_Dir $Mapper $Reducer $Output_Dir

