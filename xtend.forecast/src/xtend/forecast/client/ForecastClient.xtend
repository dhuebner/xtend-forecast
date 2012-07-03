package xtend.forecast.client

import javafx.application.Application
import javafx.util.Callback
import org.vertx.java.core.buffer.Buffer
import org.vertx.java.core.http.HttpClient
import org.vertx.java.deploy.Verticle

/**
 * @author Dennis Huebner
 * 
 */
class ForecastClient extends Verticle implements IForecastProvider {

	HttpClient httpClient;

	override start() {
		WeatherApplication::setForecastProvider(this);
		new Thread([|Application::launch(typeof(WeatherApplication))]).start();
		httpClient = vertx.createHttpClient => [ port = 8082 host = "localhost"]
		println("Http client started");
	}

	override stop() throws Exception {
		super.stop
		httpClient?.close();
	}

	override subscribeForecast( String germanCity,
			 Callback<Buffer, Boolean> callBack) {
		// subscribe weather forecast
		println("HTTP client requesting: " + germanCity)
        httpClient.getNow("/" + germanCity) [ dataHandler[ callBack.call(it) ] ]
	}

	override unsubscribe() {
		stop
		System::exit(0)
	}
	
}