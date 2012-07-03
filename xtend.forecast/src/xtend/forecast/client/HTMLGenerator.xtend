package xtend.forecast.client

import org.vertx.java.core.json.JsonObject
import org.vertx.java.core.json.JsonArray
import static xtend.forecast.client.WeatherApplication.*
/**
 * @author Dennis Huebner
 *
 */
class HTMLGenerator {
	public static val String FORECAST_BLUE = "#93B7E4"
	
	def static createHTML(JsonObject jSonObj) {
		new HTMLGenerator().html(jSonObj)
	}
	
	def static String emptyPage() {
		'''<body bgcolor="«FORECAST_BLUE»"></body'''
	}
	
	def String html(JsonObject jSonObj) {
		val data = jSonObj.getObject("data")
		val weather = data.getArray("weather")?.firstJsonObject
		'''
		<html>
			<head>
				<style type="text/css">
				* { vertical-align: middle; }
				body { font-family:Arial; }
				td {
					text-align: center; height: 64px;
					font-size: 42px; width:300px;
				}
				.white { color: «FORECAST_BLUE»; background-color: white; }
				.blue { color: white; }
				</style>
			</head>
			<body bgcolor="«FORECAST_BLUE»">
		«if(weather!=null) {
			weather.weatherContent	
		} else {
			// { "data": { "error": [ {"msg": "Unable to find any matching weather location to the query submitted!" } ] }}
			'''<div>«data.getArray("error")?.firstJsonObject.getField("msg")»</div>'''
		}»
			</body>
		</html>
		''' 
	}

	
	def weatherContent(JsonObject weather) {
'''		<table>
			<tr><td class="blue">
				Tomorrow&nbsp;<img src="«weather.firstArrayValue("weatherIconUrl")»"/>
			</td></tr>
			<tr><td class="white" style="font-size:«if (weather.firstArrayValue("weatherDesc").length<14) "42" else "24"»px;">
				«weather.firstArrayValue("weatherDesc")»
			</td></tr>
			<tr><td class="blue">
				<img src="«imageResourceURL("temp.png")»"/>
				«weather.getField("tempMinC")»&deg;-«weather.getField("tempMaxC")»&deg;&nbsp;C
			</td></tr>
			<tr><td class="white">
				«val rotation = weather.getField("winddirDegree")»
				<img style="-webkit-transform:rotate(«rotation»deg);-moz-transform:rotate(«rotation»deg);-ms-transform:rotate(«rotation»deg);"
					 src="«imageResourceURL("wind.png")»"/>
				«weather.getField("windspeedKmph")»&nbsp;«weather.getField("winddir16Point")»
			</td></tr>
		</table>'''
	}

	def imageResourceURL(String image) {
		typeof(WeatherApplication).getResource(image).toExternalForm()
	}

		
	def  String firstArrayValue(JsonObject jObj, String fName) {
		return firstJsonObject(jObj.getArray(fName)).getField("value").toString
	}

	def  JsonObject firstJsonObject(JsonArray array) {
		(typeof(JsonObject).cast(array.iterator.next))
	}
}