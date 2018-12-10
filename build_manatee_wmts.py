
# -*- coding: utf-8 -*-

import sys
import os
import re
from mapproxy.script.util import main as map_main
import yaml 
import json

def build_caches():
    stream = open("manatee_raw.yaml", "rt")
    data = yaml.load(stream, Loader=yaml.Loader)
    print(data)
    # strip the toplayer level from the layers this is from the lizardtech server
    data["layers"] = data["layers"][0]["layers"]
    
    #for each layer in layers build a cache and then point the layer to the cache
    caches = {}
    for lyr in data["layers"]:
        src = lyr["sources"]
        srcname = src[0]
        cachename = srcname.replace('_wms', '_cache')
        lyr["sources"] = [s.replace('_wms', '_cache') for s in src]
        caches[cachename] = { "grids": ["webmercator"],
            "sources": [srcname]}
    data["caches"] = caches

    # add grid defintions and globals
    data["grids"] = {"webmercator": {"base":  'GLOBAL_WEBMERCATOR'}}
    data["globals"] = None
    
    # add additional services
       # demo
       # tms
       # wmts
       ## kml will be ignored
    data["services"]["tms"] = {"origin": "sw",  "use_grid_names": True}
    data["services"]["wmts"] = {}
    data["services"]["demo"] = {}
    data["services"]["wms"]["md"]["abstract"] = "Manatee County Published Aerial Mosaics"

    with open("manatee.yaml", "wt") as output:
        output.write(yaml.dump(data, Dumper=yaml.Dumper))

def main(args):
    #map_main(args)

    build_caches()

if __name__ == '__main__':
    WRKDIR = os.path.dirname(sys.argv[0])
    os.chdir(WRKDIR)
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(main(sys.argv))

