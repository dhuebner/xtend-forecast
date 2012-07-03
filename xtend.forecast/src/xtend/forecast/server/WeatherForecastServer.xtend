package xtend.forecast.server

import org.vertx.java.core.http.HttpServerResponse
import org.vertx.java.deploy.Verticle
import org.vertx.java.core.buffer.Buffer
import java.io.BufferedReader
import java.io.InputStreamReader

class WeatherForecastServer extends Verticle {

	override start() throws Exception {
		vertx.createHttpServer.requestHandler [
	        println("Got request: " + uri)
	        val city =  uri.split("/").last?.toLowerCase
	        response.headers.put("Content-Type", "application/json")
	        response.forecastFor(city)
		].listen(8082)
		println("Server started...")
	}

	def private forecastFor(HttpServerResponse response, String city) {
		if(!"test".equals(city)) {
			val client = vertx.createHttpClient => [
				host = "free.worldweatheronline.com"
				getNow(city.computeUri) [
					dataHandler[response.end(it)]
				]
			]
			client.close
		} else {
			response.end(new Buffer(testData.toString))
		}
	}

	def private String computeUri(String city) {
		'''/feed/weather.ashx?q=«city»&format=json&num_of_days=1&key=2351105512140058121706'''
	}
	
	def private testData(){
		val content = typeof(WeatherForecastServer).getResourceAsStream("testdata.json")
		val bufferedReader = new BufferedReader(new InputStreamReader(content));
		val stringBuilder = new StringBuilder();
		var String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			stringBuilder.append(line + "\n");
		}
		bufferedReader.close();
		return stringBuilder
	}
	
}