library meshgrid;

import 'dart:mirrors';

class MeshGrid implements List<List<int>> {
  final List<List<int>> _grid;
  int get width => _grid.length;
  int get height => _grid[0].length;

  MeshGrid(int width, int height, [int filler = 0])
      : _grid =
            new List.generate(width, (_) => new List.filled(height, filler));

  noSuchMethod(Invocation invocation) => //super.noSuchMethod(invocation);
      reflect(_grid).delegate(invocation);

  @override
  String toString() {
    String result = "";
    for (int i = 0; i < width; i++) {
      result += "[";
      for (int j = 0; j < height; j++) {
        result += this[i][j].toString().padLeft(3);
      }
      result += "]\n";
    }
    return result;
  }

  void bresenhamLine(int pX, int i, int pY, int j) {
    bool plot(int x, int y) {
      if (x < width && y < height) {
        this[x][y] = 1;
        return true;
      }
      return false;
    }

    // Bresenham's line algorithm
    int x0 = pX, x1 = i, y0 = pY, y1 = j, tmp = 0;
    var steep = (y0 - y1).abs() > (x0 - x1).abs();
    if (steep) {
      tmp = x0;
      x0 = y0;
      y0 = tmp;
      tmp = x1;
      x1 = y1;
      y1 = tmp;
    }
    if (x0 > x1) {
      tmp = x0;
      x0 = x1;
      x1 = tmp;
      tmp = y0;
      y0 = y1;
      y1 = tmp;
    }
    var dx = x1 - x0,
        dy = (y1 - y0).abs(),
        err = (dx / 2),
        ystep = (y0 < y1 ? 1 : -1),
        y = y0;
    for (int x = x0; x <= x1; ++x) {
      if (!(steep ? plot(y, x) : plot(x, y))) return;
      err = err - dy;
      if (err < 0) {
        y += ystep;
        err += dx;
      }
    }
  }
}
