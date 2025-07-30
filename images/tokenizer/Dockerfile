# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any Python dependencies
RUN pip install --no-cache-dir nltk

# Download NLTK data (punkt) during image build to avoid runtime download
RUN python -c "import nltk; nltk.download('punkt')"

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Define environment variable
ENV NAME tokenizer_server

# Run app.py when the container launches
CMD ["python", "nltk_tokenizer_server.py"]