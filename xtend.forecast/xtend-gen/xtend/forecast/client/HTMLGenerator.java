package xtend.forecast.client;

import com.google.common.base.Objects;
import java.net.URL;
import java.util.Iterator;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.vertx.java.core.json.JsonArray;
import org.vertx.java.core.json.JsonObject;
import xtend.forecast.client.WeatherApplication;

/**
 * @author Dennis Huebner
 */
@SuppressWarnings("all")
public class HTMLGenerator {
  public final static String FORECAST_BLUE = "#93B7E4";
  
  public static String createHTML(final JsonObject jSonObj) {
    HTMLGenerator _hTMLGenerator = new HTMLGenerator();
    String _html = _hTMLGenerator.html(jSonObj);
    return _html;
  }
  
  public static String emptyPage() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<body bgcolor=\"");
    _builder.append(HTMLGenerator.FORECAST_BLUE, "");
    _builder.append("\"></body");
    return _builder.toString();
  }
  
  public String html(final JsonObject jSonObj) {
    String _xblockexpression = null;
    {
      final JsonObject data = jSonObj.getObject("data");
      JsonArray _array = data.getArray("weather");
      final JsonObject weather = _array==null?(JsonObject)null:this.firstJsonObject(_array);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("<html>");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("<head>");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("<style type=\"text/css\">");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("* { vertical-align: middle; }");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("body { font-family:Arial; }");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("td {");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("text-align: center; height: 64px;");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("font-size: 42px; width:300px;");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append(".white { color: ");
      _builder.append(HTMLGenerator.FORECAST_BLUE, "		");
      _builder.append("; background-color: white; }");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t");
      _builder.append(".blue { color: white; }");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("</style>");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("</head>");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("<body bgcolor=\"");
      _builder.append(HTMLGenerator.FORECAST_BLUE, "	");
      _builder.append("\">");
      _builder.newLineIfNotEmpty();
      CharSequence _xifexpression = null;
      boolean _notEquals = (!Objects.equal(weather, null));
      if (_notEquals) {
        CharSequence _weatherContent = this.weatherContent(weather);
        _xifexpression = _weatherContent;
      } else {
        StringConcatenation _builder_1 = new StringConcatenation();
        _builder_1.append("<div>");
        JsonArray _array_1 = data.getArray("error");
        JsonObject _firstJsonObject = _array_1==null?(JsonObject)null:this.firstJsonObject(_array_1);
        Object _field = _firstJsonObject.getField("msg");
        _builder_1.append(_field, "");
        _builder_1.append("</div>");
        _xifexpression = _builder_1;
      }
      _builder.append(_xifexpression, "");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("</body>");
      _builder.newLine();
      _builder.append("</html>");
      _builder.newLine();
      _xblockexpression = (_builder.toString());
    }
    return _xblockexpression;
  }
  
  public CharSequence weatherContent(final JsonObject weather) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("\t\t");
    _builder.append("<table>");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("<tr><td class=\"blue\">");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("Tomorrow&nbsp;<img src=\"");
    String _firstArrayValue = this.firstArrayValue(weather, "weatherIconUrl");
    _builder.append(_firstArrayValue, "				");
    _builder.append("\"/>");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.append("</td></tr>");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("<tr><td class=\"white\" style=\"font-size:");
    String _xifexpression = null;
    String _firstArrayValue_1 = this.firstArrayValue(weather, "weatherDesc");
    int _length = _firstArrayValue_1.length();
    boolean _lessThan = (_length < 14);
    if (_lessThan) {
      _xifexpression = "42";
    } else {
      _xifexpression = "24";
    }
    _builder.append(_xifexpression, "			");
    _builder.append("px;\">");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t\t");
    String _firstArrayValue_2 = this.firstArrayValue(weather, "weatherDesc");
    _builder.append(_firstArrayValue_2, "				");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.append("</td></tr>");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("<tr><td class=\"blue\">");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("<img src=\"");
    String _imageResourceURL = this.imageResourceURL("temp.png");
    _builder.append(_imageResourceURL, "				");
    _builder.append("\"/>");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t\t");
    Object _field = weather.getField("tempMinC");
    _builder.append(_field, "				");
    _builder.append("&deg;-");
    Object _field_1 = weather.getField("tempMaxC");
    _builder.append(_field_1, "				");
    _builder.append("&deg;&nbsp;C");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.append("</td></tr>");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("<tr><td class=\"white\">");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    final Object rotation = weather.getField("winddirDegree");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t\t");
    _builder.append("<img style=\"-webkit-transform:rotate(");
    _builder.append(rotation, "				");
    _builder.append("deg);-moz-transform:rotate(");
    _builder.append(rotation, "				");
    _builder.append("deg);-ms-transform:rotate(");
    _builder.append(rotation, "				");
    _builder.append("deg);\"");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t\t\t ");
    _builder.append("src=\"");
    String _imageResourceURL_1 = this.imageResourceURL("wind.png");
    _builder.append(_imageResourceURL_1, "					 ");
    _builder.append("\"/>");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t\t");
    Object _field_2 = weather.getField("windspeedKmph");
    _builder.append(_field_2, "				");
    _builder.append("&nbsp;");
    Object _field_3 = weather.getField("winddir16Point");
    _builder.append(_field_3, "				");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.append("</td></tr>");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("</table>");
    return _builder;
  }
  
  public String imageResourceURL(final String image) {
    URL _resource = WeatherApplication.class.getResource(image);
    String _externalForm = _resource.toExternalForm();
    return _externalForm;
  }
  
  public String firstArrayValue(final JsonObject jObj, final String fName) {
    JsonArray _array = jObj.getArray(fName);
    JsonObject _firstJsonObject = this.firstJsonObject(_array);
    Object _field = _firstJsonObject.getField("value");
    return _field.toString();
  }
  
  public JsonObject firstJsonObject(final JsonArray array) {
    Iterator<Object> _iterator = array.iterator();
    Object _next = _iterator.next();
    JsonObject _cast = JsonObject.class.cast(_next);
    return _cast;
  }
}
