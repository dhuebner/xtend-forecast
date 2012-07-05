package xtend.forecast

import java.net.URLEncoder
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.util.EntityUtils
import org.json.JSONObject

import static extension xtend.forecast.Library.*

class Forecaster {
	
	def static forecast(String city) {
		val Forecaster instance = new Forecaster()
		try {
			new JSONObject(instance.forecastFor(city.toLowerCase))
		} catch (Exception ex) {
			instance.forecastFailed(ex)
		}
	}
	
	def  forecastFor(String city) {
		val	host = "free.worldweatheronline.com"
		val path = city.computePath
		new DefaultHttpClient().execute(
			new HttpGet("http://" + host + path), [
				EntityUtils::toString(entity)
			]
		)
	}

	def private String computePath(String city) {
		'''/feed/weather.ashx?q=ÇURLEncoder::encode(city)È&format=json&num_of_days=1&key=2351105512140058121706'''
	}
	
	
	def JSONObject forecastFailed(Exception ex) {
		new JSONObject() => [
			jsonObj("data")[
				jsonObj("error") [
					put("msg","Can get forecast. "+ex?.message)
				]
			]
		]
	}
	
}