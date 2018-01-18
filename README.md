# Game-OS-for-OC
A Operating system built to run games in open computers
## Library Documentation
  ### Basic Info
    All colors are palette colors
    The Buffer is a table structured like this
    {
      changed : bool,
      [1] = {[1]...[height]}
      .
      .
      .
      [width]
    }
    buffer[x][y] = {char,fg,bg}
  ### Graphics
    #### Point
      Usage: graphics:point(buffer : table, x : number, y : number, c : number)
      Description:
        Creates a point on the buffer at the specified coordinates with the specified color (pallete color)
        The buffer is a table that holds the entire screen data and 1 variable called changed
    #### Line
      Usage: graphics:line(buffer : table, x0 : number, x1 : number, y0 : number, y1 : number, c : number)
      Description:
        Creates a line between (x0,y0) and (x1,y1) on the buffer
    #### Trig
      Usage: graphics:trig(buffer : table, x0 : number, x1 : number, x2 : number, y0 : number, y1 : number, y2 : number, c : number)
      Description:
        Creates a triangle using the points ((x0,y0),(x1,y1),(x2,y2)) on the buffer
    #### Quad
      Usage:
        graphics:quad(buffer : table, x0 : number, x1 : number, x2 : number, x3 : number, y0 : number, y1 : number, y2 : number, c : number)
      Description:
        Creates a quadrilateral using the points ((x0,y0),(x1,y1),(x2,y2),(x3,y3)) on the buffer
    #### Poly
      Usage: graphics:poly(buffer : table, points : table, c : number)
      Description:
        Creates a polygon using the points table on the buffer
        The points table is a table of points where points are {x,y}
    #### Ellipse
      Usage: graphics:ellipse(buffer : table, x : number, y : number, w : number, h : number, c : number)
      Description:
        Creates an ellipse at x,y with width w and height h on the buffer
    #### Circle
      Usage: graphics:circle(buffer : table, x : number, y : number, r : number, c : number)
      Description:
        Creates a circle at x,y with radius r on the buffer
    #### Ellipse Fill
      Usage: graphics:ellipseFill(buffer : table, x : number, y : number, w : number, h : number, c : number)
      Description:
        Same as ellipse but filled
    #### Circle Fill
      Usage: graphics:circleFill(buffer : table, x : number, y : number, r : number, c : number)
      Description:
        Same as circle but filled
    #### Rectangle Fill
      Usage: graphics:rectFill(buffer : table, x : number, y : number, w : number, h : number, c : number)
      Description:
        Creates a filled AABB on the buffer
    #### String
      Usage: graphics:string(buffer : table, x : number, y : number, fg : number, bg : number)
      Description:
        Creates a string on the buffer
    #### Create Buffer
      Usage: graphics:createBuffer() : table
      Description:
        Creates a buffer and returns it
    #### Render
      Usage: graphics:render(buffer : table)
      Description:
        Renders a buffer to the screen if buffer.change is true then sets buffer.change to false
  ### Image
  ### Map
  ### Pallete

