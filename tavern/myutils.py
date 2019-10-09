import json

def save_response(response,filenane):
    try:
        file = open(filenane, 'w')
        #json_string = json.dumps(dict_object)
        json.dump(response.json(), file)
        file.close()
    except FileNotFoundError:
        print(filenane + " not found. ")         