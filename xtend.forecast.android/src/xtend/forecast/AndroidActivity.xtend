package xtend.forecast

import android.app.Activity
import android.graphics.Color
import android.os.Bundle
import android.widget.EditText
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.LinearLayout$LayoutParams
import android.widget.TextView
import java.net.URL
import org.json.JSONObject

import static android.widget.LinearLayout.*

import static extension xtend.forecast.Library.*

class AndroidActivity extends Activity {
	
	EditText searchField
	ImageView weatherImage
	TextView infoText
	TextView forecastText
	TextView tempText
	TextView windText
	ImageView windImage
	
	 /** Called when the activity is first created. */
   override void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState)
        contentView = new LinearLayout(this) => [
        	orientation = VERTICAL
        	row[
        		textField [ searchField = it text = "Kiel"].weight(1)
        		button [ 
        			text = "Search"
        			onClickListener = [
        				val JSONObject jsonObj = Forecaster::forecast(searchField.text.toString)
        				val data = jsonObj.firstEntry("data")
        				val error = data.firstEntry("error")
        				if (error != null) {
        					infoText.text = error.getString("msg")
        					return
        				}
        				loadValues(data)
        			]
        		]
        	]
        	
        	row[
        		label[ infoText = it text = "Enter a city" ]
        	]
        	
        	row[
        		image[ weatherImage = it]
        		label[ forecastText = it text = "... and hit search" textColor = Color::WHITE]
        		backgroundColor = Color::parseColor("#93B7E4")
        	]
        	
        	row[
        		image[ imageDrawable = resources.getDrawable(R$drawable::ic_temp_2) ]
        		label[ tempText = it text = "?¡ - ?¡ C" ]
        		backgroundColor = Color::WHITE
        	]
        	
        	row[
        		windImage = image[ imageDrawable = resources.getDrawable(R$drawable::ic_wind) ]
        		windText = label[ text = "?km/h - ?" ]
        		backgroundColor = Color::WHITE
        	]
        ]
        
    }
	
	def private void loadValues(JSONObject data) {
		val weather = data.firstEntry("weather")
		// Info
		infoText.text = '''Tomorrow in Çdata.firstEntry("request").getString("query")È'''
		// Image
		val imageUrl = weather.firstEntry("weatherIconUrl").getString("value")
		weatherImage.setImageDrawable(createDrawable(new URL(imageUrl)))
		weatherImage.layoutParams = new LinearLayout$LayoutParams(windImage.width,windImage.height)
		// Weather
		forecastText.text =  weather.firstEntry("weatherDesc").getString("value")
		// Temperature
		tempText.text = '''Çweather.getString("tempMinC")È¡ - Çweather.getString("tempMaxC")È¡ C'''
		// Wind
		windText.text = '''Çweather.getString("windspeedKmph")Èkm/h - Çweather.getString("winddir16Point")È'''
		windImage.rotate(180 + weather.getInt("winddirDegree"))
	}
	
}
