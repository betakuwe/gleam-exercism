import gleam/list

// TODO: please define the Pizza custom type
pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  pizza_price_loop(pizza, 0)
}

fn pizza_price_loop(pizza: Pizza, price: Int) -> Int {
  case pizza {
    Margherita -> 7 + price
    Caprese -> 9 + price
    Formaggio -> 10 + price
    ExtraSauce(pizza) -> pizza_price_loop(pizza, 1 + price)
    ExtraToppings(pizza) -> pizza_price_loop(pizza, 2 + price)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  list.fold(
    over: order,
    from: case list.length(order) {
      1 -> 3
      2 -> 2
      _ -> 0
    },
    with: fn(price, pizza) { price + pizza_price(pizza) },
  )
}
