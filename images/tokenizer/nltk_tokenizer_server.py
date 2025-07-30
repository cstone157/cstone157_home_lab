import socket
import json
import nltk
from nltk.tokenize import word_tokenize

# Download necessary NLTK data (only needs to be done once)
try:
  nltk.data.find("tokenizers/punkt")
except LookupError:
  nltk.download('punkt')  # Download Punkt sentence tokenizer if not present
except Exception as e:
  print(f"Error downloading nltk data: {e}")


def tokenize_and_jsonify(message):
  """
  Tokenizes a message using NLTK's word_tokenize and returns it as a JSON array.

  Args:
    message: The string message to tokenize.

  Returns:
    A JSON string representing the tokenized message as an array.
  """
  try:
    tokens = word_tokenize(message)  # Use nltk.word_tokenize for tokenization
    return json.dumps(tokens)
  except Exception as e:  #Catch general exceptions during tokenizing
    return json.dumps({"error": str(e)})

def main():
  """
  Sets up a socket server, listens for messages on port 3000,
  tokenizes the message using nltk, and sends it back as a JSON array.
  """

  HOST = 'localhost'  # Listen on localhost
  PORT = 3000

  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print(f"Listening on {HOST}:{PORT}")

    conn, addr = s.accept()
    with conn:
      print(f"Connected by {addr}")
      while True:
        data = conn.recv(1024)  # Receive up to 1024 bytes
        if not data:
          break

        message = data.decode('utf-8') # Decode the message from bytes
        print(f"Received: {message}")

        tokenized_json = tokenize_and_jsonify(message)  # Tokenize and jsonify
        conn.sendall(tokenized_json.encode('utf-8'))  # Send the JSON back
        print(f"Sent: {tokenized_json}")
        break # break after processing one message

if __name__ == "__main__":
  main()