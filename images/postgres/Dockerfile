FROM postgres:15.6

# COPY ALL OF OUR DATA_SHEETS OVER (We copy all of them over since there's no conditional COPY)
RUN mkdir preloaded_data
COPY /preloaded_data/ preloaded_data

# Retrieve all of the files from the folder
RUN file="$(ls -1 /preloaded_data)" && echo $file

RUN array=$(ls ./preloaded_data -1); for i in ${array}; do cp ./preloaded_data/$i /docker-entrypoint-initdb.d/$i; echo $i; done

# Cleanup
RUN rm -rf /preloaded_data