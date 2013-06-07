package xtend.forecast

import android.app.Activity
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.widget.EditText
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import java.net.URL
import org.json.JSONObject

import static android.widget.LinearLayout.*
import static xtend.forecast.R.drawable.*

import static extension xtend.forecast.Library.*

/**
 * Copyright (c) 2011 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * @author Dennis Huebner - Initial contribution and API
 */
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
				textField [searchField = it text = "Kiel"].weight(1)
				button [
					text = "Search"
					onClickListener = [
						val JSONObject jsonObj = Forecaster.forecast(searchField.text.toString)
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
			row[label[infoText = it text = "Enter a city"]]
			row[
				image[weatherImage = it]
				label[forecastText = it text = "... and hit search" textColor = Color.WHITE]
				backgroundColor = Color.parseColor("#93B7E4")
			]
			row[
				image[imageDrawable = ic_temp_2.drawable]
				label[tempText = it text = "?° - ?° C"]
				backgroundColor = Color.WHITE
			]
			row[
				image[windImage = it imageDrawable = ic_wind.drawable]
				label[windText = it text = "?km/h - ?"]
				backgroundColor = Color.WHITE
			]
		]

	}

	def private Drawable getDrawable(int id) {
		resources.getDrawable(id)
	}

	def private void loadValues(JSONObject data) {
		val weather = data.firstEntry("weather")

		// Info
		infoText.text = '''Tomorrow in «data.firstEntry("request").getString("query")»'''

		// Image
		val imageUrl = weather.firstEntry("weatherIconUrl").getString("value")
		weatherImage.setImageDrawable(createDrawable(new URL(imageUrl)))
		weatherImage.layoutParams = new LinearLayout.LayoutParams(windImage.width, windImage.height)

		// Weather
		forecastText.text = weather.firstEntry("weatherDesc").getString("value")

		// Temperature
		tempText.text = '''«weather.getString("tempMinC")» - «weather.getString("tempMaxC")» C'''

		// Wind
		windText.text = '''«weather.getString("windspeedKmph")»km/h - «weather.getString("winddir16Point")»'''
		windImage.rotate(180 + weather.getInt("winddirDegree"))
	}

}
