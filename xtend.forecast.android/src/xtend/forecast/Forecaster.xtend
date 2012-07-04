package xtend.forecast

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.util.EntityUtils
import java.net.URLEncoder

class Forecaster {
	
	def static forecast(String city) {
		new Forecaster().forecastFor(city.toLowerCase)
	}
	
	def  forecastFor(String city) {
		if(!"test".equals(city)) {
			val	host = "free.worldweatheronline.com"
			val path = city.computePath
			new DefaultHttpClient().execute(new HttpGet("http://" + host + path), [
				try {
					EntityUtils::toString(entity)
				} catch (IOException ioEx) {
					println("Request failed!")
				}
			])
		} else {
			testData
		}
	}

	def private String computePath(String city) {
		'''/feed/weather.ashx?q=ÇURLEncoder::encode(city)È&format=json&num_of_days=1&key=2351105512140058121706'''
	}
	
	def private testData() {
		val iStream = typeof(Forecaster).getResourceAsStream("testdata.json")
		iStream.asStringBuffer
	}
	
	def private asStringBuffer(InputStream is) {
		val bufferedReader = new BufferedReader(new InputStreamReader(is));
		val stringBuilder = new StringBuilder();
		var String line = null;
		while ((line = bufferedReader.readLine())!=null) {
			stringBuilder.append(line + "\n");
		}
		bufferedReader.close();
		return stringBuilder
	}
}