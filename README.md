Helper Scripts to import and pre-model OSM data for a Manatee County OSM impirt of buildings, addresses, and POIs


## for WMTS use of Manatee Aerial images in Id 
* install mapproxy
   * pip install -r requirements --user
* build a cache definition for Manatee
   * mapproxy-util autoconfig --capabilities \
    https://www.mymanatee.org/lizardtech/iserv/ows? --output \
    manatee_raw.yaml --output-seed manatee_seed.yaml --force

* post-process the manatee definitions to include WMTS and TMS support
   * python ./build_manatee_wmts.py

* start the mapproxy service
   * mapproxyi-util serve-develop manatee.yaml 

* open Id and add a custom maplayer
   * http://127.0.0.1:8080/wmts/2017CIR/webmercator/{zoom}/{x}/{y}.png

* or use the mapproxy demo to get other layer names
    * http://127.0.0.1:8080/demo
