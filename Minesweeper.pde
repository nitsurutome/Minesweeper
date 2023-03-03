import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();
public boolean uLost = false;

public void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS]; //first call to new
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c); //second call to new
    }
  }

  for (int i = 0; i < 15; i++) //change i < 1 to set amt of mines
  {    
    setMines();
  }
}
public void setMines()
{
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (mines.contains(buttons[row][col])) {
  } else mines.add(buttons[row][col]);
}

public void draw ()
{
  background( 0 );
}
public boolean isWon()
{
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      if (!(mines.contains(buttons[i][j])) && !(buttons[i][j].clicked))
      {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int i = 0; i < mines.size(); i++)
  {
    mines.get(i).clicked = true;
    mines.get(i).draw();
  }
}
public void displayWinningMessage()
{
  textSize(90);
  text("YOU WIN", 200, 180);
}
public boolean isValid(int r, int c)
{
  boolean valid = false;
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) valid = true;
  return valid;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if (isValid(row-1, col) == true && mines.contains(buttons[row-1][col])) numMines++;
  if (isValid(row, col-1) == true && mines.contains(buttons[row][col-1])) numMines++;
  if (isValid(row-1, col-1) == true && mines.contains(buttons[row-1][col-1])) numMines++;
  if (isValid(row-1, col+1) == true && mines.contains(buttons[row-1][col+1])) numMines++;
  if (isValid(row+1, col-1) == true && mines.contains(buttons[row+1][col-1])) numMines++;
  if (isValid(row, col+1) == true && mines.contains(buttons[row][col+1])) numMines++;
  if (isValid(row+1, col) == true && mines.contains(buttons[row+1][col])) numMines++;
  if (isValid(row+1, col+1) == true && mines.contains(buttons[row+1][col+1])) numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT)
      flagged = true;
    else if (mines.contains(this)) {
      displayLosingMessage();
      uLost = true;
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
      //else recursively call mousePressed with the valid, unclicked, neighboring buttons in all 8 directions
    } else
    {
      //LEFT NEIGHBOR
      if (isValid(myRow, myCol-1) && !(buttons[myRow][myCol-1].clicked)) {
        buttons[myRow][myCol-1].mousePressed();
      }
      //RIGHT NEIGHBOR
      if (isValid(myRow, myCol+1) && !(buttons[myRow][myCol+1].clicked)) {
        buttons[myRow][myCol+1].mousePressed();
      }
      //UP NEIGHBOR
      if (isValid(myRow-1, myCol) && !(buttons[myRow-1][myCol].clicked)) {
        buttons[myRow-1][myCol].mousePressed();
      }
      //DOWN NEIGHBOR
      if (isValid(myRow+1, myCol) && !(buttons[myRow+1][myCol].clicked)) {
        buttons[myRow+1][myCol].mousePressed();
      //DIAG
      if (isValid(myRow+1, myCol+1) && !(buttons[myRow+1][myCol+1].clicked)) {
        buttons[myRow+1][myCol+1].mousePressed();
      }
        if (isValid(myRow-1, myCol-1) && !(buttons[myRow-1][myCol-1].clicked)) {
        buttons[myRow-1][myCol-1].mousePressed();
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    textSize(10);
    text(myLabel, x+width/2, y+height/2);
    if (isWon() == true) {
      displayWinningMessage();
    }
    if (uLost == true)
    {
      textSize(80);
      text("YOU LOSE", 200, 180);
    }
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
