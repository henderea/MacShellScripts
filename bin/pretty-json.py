#!/usr/bin/env python3

import decimal
import sys

import simplejson as json
from simplejson import OrderedDict

for i in range(1, len(sys.argv)):
    fname = sys.argv[i]
    if fname.endswith(".json"):
        try:
            file = open(fname, 'r')
        except OSError:
            print(fname, " --> not found")
            continue

        data = file.read()

        file.close()

        try:
            obj = json.loads(data,
                             object_pairs_hook=OrderedDict,
                             parse_float=decimal.Decimal)
        except Exception:
            print(fname, " --> could not parse")
            continue

        output_json = json.dumps(obj,
                                 indent=2,
                                 ensure_ascii=False,
                                 sort_keys=False,
                                 separators=(",", ": "),
                                 use_decimal=True)


        if data == output_json:
            print(fname, " --> unchanged")
        else:
            file = open(fname, 'w')
            file.write(output_json)
            file.close()
            print(fname, " --> formatted")
    else:
        print(fname, " --> unsupported filetype")