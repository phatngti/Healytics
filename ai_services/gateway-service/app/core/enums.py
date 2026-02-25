from enum import Enum

class EventType(str, Enum):
    TOKEN = "token"
    NER = "ner"
    RECOMMENDATION = "recommendation"
    DONE = "done"
    ERROR = "error"