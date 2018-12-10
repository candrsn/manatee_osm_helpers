
DB=manatee_cama.sqlite

for z in manatee_property_owners.zip manatee_situs_addresses.zip manatee_ccdf.zip; do
	unzip -d cama $z
done

for z in Parcels.zip; do
    unzip -d opendata Parcels.zip
done

rm $DB
ogr2ogr -f sqlite manatee_cama.sqlite opendata/Parcels.shp -nln parcels -nlt PROMOTE_TO_MULTI -dsco SPATIALITE=yes


echo "
pragma SYNCHRONOUS=off;
.mode csv
.headers on
.import 'manatee_permit_data.csv' permit_data

.import 'cama/manatee_property_owners.csv' property_owners
.import 'cama/manatee_situs_addresses.csv' situs_addresses
.import 'cama/manatee_ccdf.csv' cama_file


" | sqlite3 $DB


echo "
pragma SYNCHRONOUS=off;
.load mod_spatialite

CREATE INDEX parcels__parid__ind on parcels(parcel_id);
ALTER TABLE permit_data ADD geometry Point;
UPDATE permit_data SET geometry = (
   SELECT st_centroid(p.geometry) 
       FROM parcels as p
       WHERE
         p.parcel_id = 
         permit_data.parid
    );

SELECT recovergeometrycolumn('permit_data','geometry',4326,'point','XY');

" | sqlite3 $DB
#REST URIs

# https://www.mymanatee.org/arcgis02/rest/services/agol/opendata/FeatureServer/5/query?outFields=*&where=1%3D1

# https://www.mymanatee.org/arcgis02/rest/services/agol/opendata/FeatureServer/0/query?outFields=*&where=1%3D1

