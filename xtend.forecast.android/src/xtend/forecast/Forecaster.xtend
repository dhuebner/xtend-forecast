package xtend.forecast

import java.io.IOException
import java.net.URLEncoder
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.util.EntityUtils
import org.json.JSONObject

class Forecaster {
	
	def static forecast(String city) {
		new JSONObject(new Forecaster().forecastFor(city.toLowerCase))
	}
	
	def  forecastFor(String city) {
			val	host = "free.worldweatheronline.com"
			val path = city.computePath
			new DefaultHttpClient().execute(new HttpGet("http://" + host + path), [
				try {
					EntityUtils::toString(entity)
				} catch (IOException ioEx) {
					println("Request failed!")
				}
			])
	
	}

	def private String computePath(String city) {
		'''/feed/weather.ashx?q=ÇURLEncoder::encode(city)È&format=json&num_of_days=1&key=2351105512140058121706'''
	}
	
}