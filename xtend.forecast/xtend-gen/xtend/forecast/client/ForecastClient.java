package xtend.forecast.client;

import javafx.application.Application;
import javafx.util.Callback;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.vertx.java.core.Handler;
import org.vertx.java.core.buffer.Buffer;
import org.vertx.java.core.http.HttpClient;
import org.vertx.java.core.http.HttpClientResponse;
import org.vertx.java.deploy.Verticle;
import xtend.forecast.client.IForecastProvider;
import xtend.forecast.client.WeatherApplication;

/**
 * @author Dennis Huebner
 */
@SuppressWarnings("all")
public class ForecastClient extends Verticle implements IForecastProvider {
  private HttpClient httpClient;
  
  public void start() {
    WeatherApplication.setForecastProvider(this);
    final Procedure0 _function = new Procedure0() {
        public void apply() {
          Application.launch(WeatherApplication.class);
        }
      };
    Thread _thread = new Thread(new Runnable() {
        public void run() {
          _function.apply();
        }
    });
    _thread.start();
    HttpClient _createHttpClient = this.vertx.createHttpClient();
    final Procedure1<HttpClient> _function_1 = new Procedure1<HttpClient>() {
        public void apply(final HttpClient it) {
          it.setPort(8082);
          it.setHost("localhost");
        }
      };
    HttpClient _doubleArrow = ObjectExtensions.<HttpClient>operator_doubleArrow(_createHttpClient, _function_1);
    this.httpClient = _doubleArrow;
    InputOutput.<String>println("Http client started");
  }
  
  public void stop() throws Exception {
    super.stop();
    if (this.httpClient!=null) this.httpClient.close();
  }
  
  public void subscribeForecast(final String germanCity, final Callback<Buffer,Boolean> callBack) {
    String _plus = ("HTTP client requesting: " + germanCity);
    InputOutput.<String>println(_plus);
    String _plus_1 = ("/" + germanCity);
    final Procedure1<HttpClientResponse> _function = new Procedure1<HttpClientResponse>() {
        public void apply(final HttpClientResponse it) {
          final Procedure1<Buffer> _function = new Procedure1<Buffer>() {
              public void apply(final Buffer it) {
                callBack.call(it);
              }
            };
          it.dataHandler(new Handler<Buffer>() {
              public void handle(Buffer event) {
                _function.apply(event);
              }
          });
        }
      };
    this.httpClient.getNow(_plus_1, new Handler<HttpClientResponse>() {
        public void handle(HttpClientResponse event) {
          _function.apply(event);
        }
    });
  }
  
  public void unsubscribe() {
    try {
      this.stop();
      System.exit(0);
    } catch (Exception _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
