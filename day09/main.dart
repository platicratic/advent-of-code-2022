import 'dart:io';

class Pair {
  int x, y;

  Pair(this.x, this.y);

  @override
  bool operator ==(final Object other) {
    return (other is Pair && other.x == x && other.y == y);
  }

  @override
  int get hashCode => Object.hash(x, y);
}

Map<String, Pair> direction = {'U': Pair(-1, 0), 'R': Pair(0, 1), 'D': Pair(1, 0), 'L': Pair(0, -1)};
List<Pair> K1 = [Pair(-1, 0), Pair(-1, 1), Pair(0, 1), Pair(1, 1), Pair(1, 0), Pair(1, -1), Pair(0, -1), Pair(-1, -1)];
List<Pair> K2 = [Pair(-1, 0), Pair(0, 1), Pair(1, 0), Pair(0, -1)];

bool isTouching(final Pair tail, final Pair head, final List<Pair> K) {
  if (tail == head) return true;
  for (int k = 0; k < K.length; k++) {
    Pair pos = Pair(tail.x + K[k].x, tail.y + K[k].y);
    if (pos == head) return true;
  }
  return false;
}

bool catchUpWithHead(final Pair tail, final Pair head, final List<Pair> K) {
  for (int k = 0; k < K1.length; k++) {
    Pair newPosition = Pair(tail.x + K1[k].x, tail.y + K1[k].y);
    if (isTouching(newPosition, head, K)) {
      tail.x = newPosition.x;
      tail.y = newPosition.y;
      return true;
    }
  }
  return false;
}

void motion(final Pair d, int times, final List<Pair> snake, final Set<Pair> tails) {
  while (times > 0) {
    snake[0].x += d.x;
    snake[0].y += d.y;
    for (int i = 1; i < snake.length; i ++) {
      if (!isTouching(snake[i], snake[i - 1], K1)) {
        (catchUpWithHead(snake[i], snake[i - 1], K2) ? null : catchUpWithHead(snake[i], snake[i - 1], K1) );
      }
    }
    tails.add(Pair(snake.last.x, snake.last.y));
    times--;
  }
}

void solve(final List<String> moves, final int snakeLength) {
  Set<Pair> tails = <Pair>{Pair(0, 0)};
  List<Pair> snake = List.generate(snakeLength, (_) => Pair(0, 0));

  for (String move in moves) {
    List<String> split = move.split(' ');
    motion(direction[split[0]]!, int.parse(split[1]), snake, tails);
  }
  print(tails.length);
}

void main() {
  List<String> moves = File('input.txt').readAsLinesSync();
  solve(moves, 2);
  solve(moves, 10);
}
