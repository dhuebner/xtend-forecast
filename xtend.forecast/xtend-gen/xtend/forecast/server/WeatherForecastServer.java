package xtend.forecast.server;

import com.google.common.base.Objects;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.vertx.java.core.Handler;
import org.vertx.java.core.buffer.Buffer;
import org.vertx.java.core.http.HttpClient;
import org.vertx.java.core.http.HttpClientResponse;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.http.HttpServerRequest;
import org.vertx.java.core.http.HttpServerResponse;
import org.vertx.java.deploy.Verticle;

@SuppressWarnings("all")
public class WeatherForecastServer extends Verticle {
  public void start() throws Exception {
    HttpServer _createHttpServer = this.vertx.createHttpServer();
    final Procedure1<HttpServerRequest> _function = new Procedure1<HttpServerRequest>() {
        public void apply(final HttpServerRequest it) {
          String _plus = ("Got request: " + it.uri);
          InputOutput.<String>println(_plus);
          String[] _split = it.uri.split("/");
          String _last = IterableExtensions.<String>last(((Iterable<String>)Conversions.doWrapArray(_split)));
          final String city = _last==null?(String)null:_last.toLowerCase();
          Map<String,Object> _headers = it.response.headers();
          _headers.put("Content-Type", "application/json");
          WeatherForecastServer.this.forecastFor(it.response, city);
        }
      };
    HttpServer _requestHandler = _createHttpServer.requestHandler(new Handler<HttpServerRequest>() {
        public void handle(HttpServerRequest event) {
          _function.apply(event);
        }
    });
    _requestHandler.listen(8082);
    InputOutput.<String>println("Server started...");
  }
  
  private void forecastFor(final HttpServerResponse response, final String city) {
    boolean _equals = "test".equals(city);
    boolean _not = (!_equals);
    if (_not) {
      HttpClient _createHttpClient = this.vertx.createHttpClient();
      final Procedure1<HttpClient> _function = new Procedure1<HttpClient>() {
          public void apply(final HttpClient it) {
            it.setHost("free.worldweatheronline.com");
            String _computeUri = WeatherForecastServer.this.computeUri(city);
            final Procedure1<HttpClientResponse> _function = new Procedure1<HttpClientResponse>() {
                public void apply(final HttpClientResponse it) {
                  final Procedure1<Buffer> _function = new Procedure1<Buffer>() {
                      public void apply(final Buffer it) {
                        response.end(it);
                      }
                    };
                  it.dataHandler(new Handler<Buffer>() {
                      public void handle(Buffer event) {
                        _function.apply(event);
                      }
                  });
                }
              };
            it.getNow(_computeUri, new Handler<HttpClientResponse>() {
                public void handle(HttpClientResponse event) {
                  _function.apply(event);
                }
            });
          }
        };
      final HttpClient client = ObjectExtensions.<HttpClient>operator_doubleArrow(_createHttpClient, _function);
      client.close();
    } else {
      StringBuilder _testData = this.testData();
      String _string = _testData.toString();
      Buffer _buffer = new Buffer(_string);
      response.end(_buffer);
    }
  }
  
  private String computeUri(final String city) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("/feed/weather.ashx?q=");
    _builder.append(city, "");
    _builder.append("&format=json&num_of_days=1&key=2351105512140058121706");
    return _builder.toString();
  }
  
  private StringBuilder testData() {
    try {
      final InputStream content = WeatherForecastServer.class.getResourceAsStream("testdata.json");
      InputStreamReader _inputStreamReader = new InputStreamReader(content);
      BufferedReader _bufferedReader = new BufferedReader(_inputStreamReader);
      final BufferedReader bufferedReader = _bufferedReader;
      StringBuilder _stringBuilder = new StringBuilder();
      final StringBuilder stringBuilder = _stringBuilder;
      String line = null;
      String _readLine = bufferedReader.readLine();
      String _line = line = _readLine;
      boolean _notEquals = (!Objects.equal(_line, null));
      boolean _while = _notEquals;
      while (_while) {
        String _plus = (line + "\n");
        stringBuilder.append(_plus);
        String _readLine_1 = bufferedReader.readLine();
        String _line_1 = line = _readLine_1;
        boolean _notEquals_1 = (!Objects.equal(_line_1, null));
        _while = _notEquals_1;
      }
      bufferedReader.close();
      return stringBuilder;
    } catch (Exception _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
