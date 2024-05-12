import argparse


def read_file(path):
    map = []
    with open(path) as fp:
        rows = fp.readlines()
    for row in rows:
        row = [int(number) for number in row if number != '\n']
        map.append(row)
    return map


class Node():
    def __init__(self, column, row, matrix) -> None:
        self.column = column
        self.row = row
        self.cost = matrix[row][column]
        self.matrix = matrix
        self.distance = float("inf")
        self.previous = None

    def __repr__(self):
        return ("(" + str(self.column) + ", " + str(self.row) + ") -> " + str(self.distance))

    def __lt__(self, other) -> bool:
        return self.distance < other.distance

    def __eq__(self, other) -> bool:
        return self.column == other.column and self.row == other.row

    def up(self):
        if (self.row-1) >= 0:
            return Node(self.column, self.row-1, self.matrix)
        else:
            return None

    def down(self):
        if (self.row+1) < len(self.matrix):
            return Node(self.column, self.row+1, self.matrix)
        else:
            return None

    def left(self):
        if (self.column-1) >= 0:
            return Node(self.column-1, self.row, self.matrix)
        else:
            return None

    def right(self):
        if (self.column+1) < len(self.matrix[self.row]):
            return Node(self.column+1, self.row, self.matrix)
        else:
            return None

    def find_way(self):
        path = []
        current = self
        while current is not None:
            path.append(current)
            current = current.previous
        return path


def find_points(matrix):
    points = []
    for row in range(len(matrix)):
        for column in range(len(matrix[row])):
            if matrix[row][column] == 0:
                points.append(Node(column, row, matrix))
    if len(points) != 2:
        raise ValueError()
    return points


def dijkstra_algorithm(matrix):
    points = find_points(matrix)
    beginning = points[0]
    end = points[1]
    unvisited = []
    visited = []

    for row in range(len(matrix)):
        for column in range(len(matrix[row])):
            node = Node(column, row, matrix)
            unvisited.append(node)
            if node == beginning:
                node.distance = 0

    while unvisited:
        current_node = min(unvisited)
        unvisited.remove(current_node)

        neighbours = [current_node.left(), current_node.right(),
                      current_node.up(), current_node.down()]
        neighbours = [
            neighbour for neighbour in neighbours if neighbour is not None]
        neighbours = [
            neighbour for neighbour in unvisited if neighbour in neighbours]

        for neighbour in neighbours:
            costs = current_node.distance + neighbour.cost
            if costs < neighbour.distance:
                neighbour.distance = costs
                neighbour.previous = current_node

        visited.append(current_node)
    index = visited.index(end)

    return visited[index].find_way()


def print_path(matrix):
    way = dijkstra_algorithm(matrix)
    word = ""
    for row in range(len(matrix)):
        for column in range(len(matrix[row])):
            if Node(column, row, matrix) not in way:
                word += " "
            else:
                cost = matrix[row][column]
                word += f'{cost}'
        word += '\n'
    print(word)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("path", help="path to txt file", type=str)
    args = parser.parse_args()
    file = read_file(args.path)
    print_path(file)

#tab = [[1, 0, 1, 4], [5, 6, 1, 8], [9, 9, 1, 1], [0, 1, 1, 1]]
# print(dijkstra_algorithm(tab))
# print_path(tab)
