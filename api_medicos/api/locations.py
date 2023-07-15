import googlemaps
from api.MySecrets import secrets
import time
import pandas as pd

API_KEY = secrets["MAPS_API_KEY"]

map_client = googlemaps.Client(API_KEY)

def getbusiness_list(location,search_string):

	# location = (26.081478208142265, 91.5619264269862)

	# search_string = 'Fungal infection'
	distance  = 30000
	business_list = []

	response = map_client.places_nearby(
		location = location,
		keyword=search_string,
		name = "Hospital",
		radius=distance
	)

	business_list.extend(response.get('results'))
	next_page_token = response.get('next_page_token')

	while next_page_token:
		time.sleep(2)
		response = map_client.places_nearby(
			location = location,
			keyword=search_string,
			radius=distance,
			page_token=next_page_token
			)
		business_list.extend(response.get('results'))
		next_page_token = response.get('next_page_token')

	df = pd.DataFrame(business_list)
	df['url'] =  'https://www.google.com/maps/place/?q=place_id:' + df['place_id']
	rslt_df = df[df["business_status"]=="OPERATIONAL"]
	rslt_df = rslt_df[["geometry","icon","name","rating","user_ratings_total","vicinity","url"]] 
	rslt_df = rslt_df.astype(str)
	# df.to_csv('Nearby Hospitals list.csv')
	return rslt_df.to_dict('records')