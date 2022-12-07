import 'dart:io';

class Node<T> {
  T value;
  Node<T>? parent;
  List<Node<T>> children = [];

  Node(this.value, this.parent);
}

Node<int> root(Node<int> tree) {
  while (tree.parent != null) {
    tree = tree.parent!;
  }
  return tree;
}

Node<int> createTree(final List<String> output) {
  Node<int> tree = Node(0, null);
  for (String line in output) {
    if (line[0] == '\$') {
      if (line[2] == 'c') {
        if (line[5] == '/') {
          root(tree);
        }
        else if (line[5] == '.') {
          tree = tree.parent!;
        }
        else {
          tree.children.add(Node(0, tree));
          tree = tree.children.last;
        }
      }
    }
    else if (line[0] != 'd') {
      tree.value += int.parse(line.split(' ')[0]);
    }
  }
  return tree;
}

int sum = 0;
int traversal1(final Node<int> tree) {
  for (Node<int> child in tree.children) {
    tree.value += traversal1(child);
  }
  if (tree.value <= 100000) {
    sum += tree.value;
  }
  return tree.value;
}

void partOne(Node<int> tree) {
  traversal1(root(tree));
  print(sum);
}

void traversal2(final Node<int> tree, List<int> nodes) {
  for (Node<int> child in tree.children) {
    traversal2(child, nodes);
  }
  nodes.add(tree.value);
}

void partTwo(Node<int> tree) {
  List<int> nodes = [];
  traversal2(root(tree), nodes);
  nodes.sort();
  print(nodes.firstWhere((int it) => it >= nodes.last - 40000000));
}

void main() {
  List<String> output = File('input.txt').readAsLinesSync().skip(1).toList();
  Node<int> tree = createTree(output);
  partOne(tree);
  partTwo(tree);
}