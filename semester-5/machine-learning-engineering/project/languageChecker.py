import requests

URL = 'https://api-free.deepl.com/v2/translate'
HEADERS = {'Authorization':'DeepL-Auth-Key 1ee424c2-f5eb-007a-a7f6-3bb79448c342:fx'}

def checkLanguage(data):
    requestData = {'text': data, 'target_lang': 'EN'}
    response = requests.get(url=URL, headers=HEADERS, data=requestData)
    if (response.status_code == 200):
        result = response.json()
        return result['translations'][0]['detected_source_language']
    else:
        raise ValueError('Cannot use API. Check Your Authorization Key')
