import json


def save_response(response, filenane):
    try:
        file = open(filenane, 'w')
        json.dump(response.json(), file)
        file.close()
    except FileNotFoundError:
        print(filenane + " not found. ")


def save_response_part(response, filenane, part):
    try:
        file = open(filenane, 'w')
        json.dump(response.json()[part], file)
        file.close()
    except FileNotFoundError:
        print(filenane + " not found. ")
