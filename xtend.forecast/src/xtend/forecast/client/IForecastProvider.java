/**
 * 
 */
package xtend.forecast.client;

import org.vertx.java.core.buffer.Buffer;

import javafx.util.Callback;

/**
 * @author Dennis Huebner
 *
 */
public interface IForecastProvider {
	void subscribeForecast(String city, Callback<Buffer, Boolean> callBack);
	void unsubscribe();
}
