

osmium extract -F pbf ../osm/florida-latest-internal.osm.pbf -o manatee_osm.pbf -p manatee_bounds.geojson -O

osmium show manatee_osm.pbf | grep user  | sort -u -s > users.txt

osmium show manatee_osm.pbf | sed 's/\x1b\[[0-9;]*m//g' > man.info

OGR_SQLITE_SYNCHRONOUS=off 

ogr2ogr -f sqlite manatee_osm.sqlite manatee_osm.pbf -oo CONFIG_FILE="osmconfig.ini"

echo "
.mode csv
.headers on
.output 'timeaudit.csv'

SELECT count(*) as edits, strftime('%s', osm_timestamp)/(60*60*24*7*4) as stat_period , 
    strftime('%m-%Y', osm_timestamp) as month FROM lines GROUP BY 2;

" | sqlite3 manatee_osm.sqlite


