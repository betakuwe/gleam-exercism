import gleam/float
import gleam/list
import gleam/order.{type Order}

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub fn fahrenheit_to_celsius(f: Float) -> Float {
  { f -. 32.0 } /. 1.8
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
  float.compare(to_celcius(left), to_celcius(right))
}

fn to_celcius(temp: Temperature) -> Float {
  case temp {
    Celsius(celcius) -> celcius
    Fahrenheit(fahrenheit) -> fahrenheit_to_celsius(fahrenheit)
  }
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
  list.sort(cities, fn(city1, city2) {
    compare_temperature(city1.temperature, city2.temperature)
  })
}
