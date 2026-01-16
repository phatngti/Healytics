import json
import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.append(ROOT_DIR)
from config.settings import SERVICE_JSON_PATH

class Service_Loader:
    def load_services(self):
        with open(SERVICE_JSON_PATH, 'r') as file:
            data = json.load(file)
        return data
    