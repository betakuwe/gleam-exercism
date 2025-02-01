import gleam/queue
import gleam/result

pub opaque type CircularBuffer(t) {
  CircularBuffer(queue: queue.Queue(t), length: Int, capacity: Int)
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  CircularBuffer(queue.new(), 0, capacity)
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  let CircularBuffer(queue, length, capacity) = buffer
  case length {
    0 -> Error(Nil)
    _ ->
      queue.pop_back(queue)
      |> result.map(fn(elem_queue_pair) {
        let #(elem, new_queue) = elem_queue_pair
        let new_buffer = CircularBuffer(new_queue, length - 1, capacity)
        #(elem, new_buffer)
      })
  }
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  let CircularBuffer(queue, length, capacity) = buffer
  case length >= capacity {
    True -> Error(Nil)
    False ->
      queue.push_front(queue, item)
      |> CircularBuffer(length + 1, capacity)
      |> Ok
  }
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  let CircularBuffer(queue, length, capacity) = buffer
  let pushed_queue = queue.push_front(queue, item)
  case length >= capacity {
    True -> {
      let assert Ok(#(_, popped_queue)) = pushed_queue |> queue.pop_back
      CircularBuffer(popped_queue, length, capacity)
    }
    False -> CircularBuffer(pushed_queue, length + 1, capacity)
  }
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  CircularBuffer(queue.new(), 0, buffer.capacity)
}
