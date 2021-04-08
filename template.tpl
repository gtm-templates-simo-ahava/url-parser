___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "__wm": "VGVtcGxhdGUtQXV0aG9yX1VSTFBhcnNlci1TaW1vLUFoYXZh",
  "version": 1,
  "securityGroups": [],
  "displayName": "URL Parser",
  "categories": ["UTILITY"],
  "description": "Parse any URL string for its constituent parts.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "urlSource",
    "displayName": "URL Source",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "default_page_location",
        "displayValue": "page_location"
      }
    ],
    "simpleValueType": true,
    "help": "Choose \u003cstrong\u003epage_location\u003c/strong\u003e to use the respective key from the Event Data object, or provide a variable that returns a valid URL string.",
    "defaultValue": "default_page_location"
  },
  {
    "type": "SELECT",
    "name": "componentType",
    "displayName": "Component Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "filenameExtension",
        "displayValue": "Filename Extension"
      },
      {
        "value": "fragment",
        "displayValue": "Fragment"
      },
      {
        "value": "fullUrl",
        "displayValue": "Full URL"
      },
      {
        "value": "hostName",
        "displayValue": "Host Name"
      },
      {
        "value": "path",
        "displayValue": "Path"
      },
      {
        "value": "port",
        "displayValue": "Port"
      },
      {
        "value": "protocol",
        "displayValue": "Protocol"
      },
      {
        "value": "query",
        "displayValue": "Query"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "fullUrl"
  },
  {
    "type": "CHECKBOX",
    "name": "stripWww",
    "checkboxText": "Strip \u0027www.\u0027",
    "simpleValueType": true,
    "help": "If enabled, the leading \u0027www.\u0027 will be stripped from the hostname.",
    "enablingConditions": [
      {
        "paramName": "componentType",
        "paramValue": "hostName",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "queryKey",
    "displayName": "Query Key (optional)",
    "simpleValueType": true,
    "help": "If provided, the value for the first query key matching the setting will be returned.",
    "enablingConditions": [
      {
        "paramName": "componentType",
        "paramValue": "query",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

// Enter your template code here.
const decodeUri = require('decodeUri');
const decodeUriComponent = require('decodeUriComponent');
const getEventData = require('getEventData');
const parseUrl = require('parseUrl');

const log = require('logToConsole');

const parsedUrl = parseUrl(data.urlSource === 'default_page_location' ? getEventData('page_location') : data.urlSource);

// If not a valid URL, return undefined
if (!parsedUrl) return;

switch (data.componentType) {
  case 'filenameExtension':
    return parsedUrl.pathname.split('.').pop();
  case 'fragment':
    return parsedUrl.hash;
  case 'fullUrl':
    return parsedUrl.href;
  case 'hostName':
    return data.stripWww ? parsedUrl.hostname.replace('www.', '') : parsedUrl.hostname;
  case 'path':
    return parsedUrl.pathname;
  case 'port':
    return parsedUrl.port;
  case 'protocol':
    return parsedUrl.protocol;
  case 'query':
    return data.queryKey ? decodeUriComponent(parsedUrl.searchParams[data.queryKey]) : parsedUrl.search;
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "page_location"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: "const mockData = {\n  urlSource: 'default_page_location',\n  componentType:\
  \ 'filenameExtension'\n};\n\nmock('getEventData', () => {\n  return 'https://www.mock-url.com:8080/test.pdf?param1=value#hash';\n\
  });\n  "


___NOTES___

Created on 02/04/2021, 20:35:12


